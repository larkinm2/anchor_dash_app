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
      @@profile = []
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

  ########################
  # Routes
  ########################

      CLIENT_ID     = "3dcc9e47c28497168cbb"
      CLIENT_SECRET = "d64574063caf092355ffcc0499a75ea531a46eec"
      CALLBACK_URL  = "http://127.0.0.1:9292/oauth_callback"

    get('/') do
    base_url = "https://github.com/login/oauth/authorize"
    scope = "user"
    # generate a random string of characters
    state = SecureRandom.urlsafe_base64
    # storing state in session because we need to compare it in a later request
    session[:state] = state
    # turn the hash into a query string
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
    # compare the states to ensure the information is from who we think it is
    if session[:state] == params[:state]
      # send a POST
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
    redirect to("/profile")
  end




    get('/editor') do
      render(:erb, :editor)
    end

    get('/dash') do
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
      @anchors = @@anchors
      render(:erb, :dash)
    end

    get('/login') do
      render(:erb, :login)
    end

    get('/profile') do
      render(:erb, :profile)
    end


    post('/dash') do
      anchor_update = {
      :weather        => params[:weather],
      :traffic        => params[:traffic],
      :sports         => params[:sports],
      :field_reporter => params[:field_reporter],
      :editor_note    => params[:editor_note]
                  }

                  @@anchors.push(anchor_update)
                  logger.info@@anchors

                end

    get('/logout') do
    session[:access_token] = nil
    redirect to("/")
  end

  get('/profile/:id') do
    render(:erb, :profile)
  end

  post('/profile/:id') do

    update_profile = {
      :name               => params[:name],
      :city               => params[:city],
      :picture_link       => params[:picture_link],
      :five_day_forecast  => params[:five_day_forecast],
      :house_bills        => params[:house_bills],
      :senate_bills       => params[:senate_bills],
      :top_stocks         => params[:top_stocks]

                  }

                  @@profile.push(update_profile)
                  logger.info@@profile
      render(:erb, :profiles)

  end

end
# @@profiles.push(profile_info)
#   @@profiles.each_with_index do |profile,index|
#   $redis.set("profiles:#{index}", profile.to_json)
