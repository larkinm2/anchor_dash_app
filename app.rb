require 'sinatra/base'
require 'httparty'
require 'pry'
require 'securerandom'
require 'twitter'
require 'yahoo_finance'
require 'uri'
require 'json'
require 'securerandom'

class App < Sinatra::Base

  ########################
  # Configuration
  ########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions
    @@anchors = []
    @@profiles = []
      # enable :logging
      # enable :method_override
      # enable :sessions
      # uri = URI.parse(ENV["REDISTOGO_URL"])
      # $redis = Redis.new({:host => uri.host,
      #                     :port => uri.port,
      #                     :password => uri.password})
    TIMES_API_KEY = "13a4a6374ae75f76bb9b710c22d043cb:3:69767050"
    WUNDERGROUND_API_KEY = "1a6e6fc49fe9c3f3"
  end


  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
     logger.info "Response Headers: #{response.headers}"
  end

    #TWIT Auth

  TWITTER_CLIENT = Twitter::REST::Client.new do |config|
    config.consumer_key        = "H7ZqbFmKWLhIyFfkiabekM1QH"
    config.consumer_secret     = "54dk4QDWcYHvPYQTGIVTYTb86dJopLMwATq8BATtAgmvqTJzv7"
    config.access_token        = "612037497-y6VvEAUpsapY8bCFGVe71yD4qRqUJkfzYz4zbDYo"
    config.access_token_secret = "ErLd7EncjzUAv7HZ89HYH157Xf3GKFV96iWkHw2goI8D8"
  end



  CLIENT_ID     = "3dcc9e47c28497168cbb"
  CLIENT_SECRET = "d64574063caf092355ffcc0499a75ea531a46eec"
  CALLBACK_URL  = "http://127.0.0.1:9292/oauth_callback"

  get('/') do
    base_url = "https://github.com/login/oauth/authorize"
    scope = "user"

  state = SecureRandom.urlsafe_base64
    session[:state] = state
      query_params = URI.encode_www_form({
                                            :client_id    => CLIENT_ID,
                                            :scope        => scope,
                                            :redirect_uri => CALLBACK_URL,
                                            :state        => state
                                       })
  @url = base_url + "?" + query_params
    render(:erb, :index)
  end

  get('/oauth_callback') do
      code = params[:code]
      if session[:state] == params[:state]
        response = HTTParty.post("https://github.com/login/oauth/access_token",
                               :body => {
                                           :client_id     => CLIENT_ID,
                                           :client_secret => CLIENT_SECRET,
                                           :code          => code,
                                           :redirect_uri  => CALLBACK_URL
                                         },
                               :headers => {
                                             "Accept" => "application/json"
                                           })
        session[:access_token] = response["access_token"]
    end
    redirect to("/profile_form")
    end




  get('/editor') do
    render(:erb, :editor)
  end

  get('/dash') do

    @user_one = JSON.parse($redis["profiles:0"])

      #Ny Times Senate vote API
      time_base_url = "http://api.nytimes.com/svc/politics/3/us/legislative/congress/"
      time_chamber_senate = "senate"
      times_date = "2014-04-03/2014-04-04"
      @time_url_senate = "http://api.nytimes.com/svc/politics/v3/us/legislative/congress/#{time_chamber_senate}/votes/#{times_date}.json?api-key=#{TIMES_API_KEY}"
      @times_senate = HTTParty.get(@time_url_senate)

      #Ny Times House Vote API
      time_chamber_house = "house"
      @time_url_house = "http://api.nytimes.com/svc/politics/v3/us/legislative/congress/#{time_chamber_house}/votes/#{times_date}.json?api-key=#{TIMES_API_KEY}"
      @times_house = HTTParty.get(@time_url_house)

      #Twitter Api
      @tweets = []
      TWITTER_CLIENT.search("senate", :result_type => "recent").take(5).each do |tweet|
          @tweets.push(tweet.text)
      end

      #Weather API
      wunderground_base = "http://api.wunderground.com/api/"
      wunderground_state = "NY"
      wunderground_city = "Brooklyn"
      @wunderground_url = "#{wunderground_base}#{WUNDERGROUND_API_KEY}/forecast10day/q/#{wunderground_state}/#{wunderground_city}.json"
      @wunderground_response = HTTParty.get(@wunderground_url)

      #Yahoo finance API
      @data = YahooFinance.quotes(["GOOG","AAPL","FORD",], [:ask,:change])
      #Github address for yahoo finance gem -- "https://github.com/herval/yahoo-finance/blob/master/README.md"
      #@anchors = @@anchors
      render(:erb, :dash)
    end

  get('/profile/edit')
    render(:erb, :profile_form)
  end

  get('/logout') do
    session[:access_token] = nil
      redirect to("/")
  end

    # post('/dash') do
    #   anchor_update = {
    #     :weather        => params[:weather],
    #     :traffic        => params[:traffic],
    #     :sports         => params[:sports],
    #     :field_reporter => params[:field_reporter],
    #     :editor_note    => params[:editor_note]
    #               }

    #               @@anchors.push(anchor_update)
    #               logger.info@@anchors

    # end

  get('/profile/edit') do
      render(:erb, :profile_form)
  end

  post('/profile/new') do
    update_profile = {
      :username           => params[:username],
      :email              => params[:user_email],
      :user_city          => params[:user_city],
      :user_state         => params[:user_state],
      :user_img           => params[:user_img],
      :house_bills        => params[:house_bills],
      :senate_bills       => params[:senate_bills],
      :top_stocks         => params[:top_stocks],
      :twitter            => params[:twitter],
      :weather            => params[:weather]

                  }

  @@profiles.push(update_profile)
    @@profiles.each_with_index do |profile, index|
      $redis.set("profiles:#{index}", profile.to_json)
  end

  logger.info@@profiles
  redirect to("/")



  get("/profile") do
    @profiles = @@profiles
      render(:erb, :profile, :template => :layout)
  end

  get("/profile/:id") do
    @profiles = @@profiles
      @index = params[:id].to_i - 1
        render(:erb, :user_profile, :template => :layout)
  end

  get ('/profile_form') do
    render(:erb, :profile_form)
  end
end

# @@profiles.push(profile_info)
#   @@profiles.each_with_index do |profile,index|
#   $redis.set("profiles:#{index}", profile.to_json)
