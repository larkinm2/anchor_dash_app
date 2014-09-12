require 'yahoo_finance'
require './application_controller'

class App < ApplicationController

    ########################
    # Configuration
    ########################
    # KEYS
    TIMES_API_KEY = '13a4a6374ae75f76bb9b710c22d043cb:3:69767050'
    WUNDERGROUND_API_KEY = '1a6e6fc49fe9c3f3'
    CLIENT_ID     = '3dcc9e47c28497168cbb'
    CLIENT_SECRET = 'd64574063caf092355ffcc0499a75ea531a46eec'
    CALLBACK_URL  = 'http://127.0.0.1:9292/oauth_callback'
    # TWIT Auth

    TWITTER_CLIENT = Twitter::REST::Client.new do |config|
      config.consumer_key        = 'H7ZqbFmKWLhIyFfkiabekM1QH'
      config.consumer_secret     = '54dk4QDWcYHvPYQTGIVTYTb86dJopLMwATq8BATtAgmvqTJzv7'
      config.access_token        = '612037497-y6VvEAUpsapY8bCFGVe71yD4qRqUJkfzYz4zbDYo'
      config.access_token_secret = 'ErLd7EncjzUAv7HZ89HYH157Xf3GKFV96iWkHw2goI8D8'
    end

    get('/') do
      base_url = 'https://github.com/login/oauth/authorize'
      scope = 'user'
      state = SecureRandom.urlsafe_base64
      session[:state] = state
      query_params = URI.encode_www_form(client_id: CLIENT_ID,
                                         scope: scope,
                                         redirect_uri: CALLBACK_URL,
                                         state: state)
      @url = base_url + '?' + query_params
      render(:erb, :index, template: :layout)
    end

    get('/oauth_callback') do
      code = params[:code]
      if session[:state] == params[:state]
        response = HTTParty.post('https://github.com/login/oauth/access_token',
                                 body: {
                                   client_id: CLIENT_ID,
                                   client_secret: CLIENT_SECRET,
                                   code: code,
                                   redirect_uri: CALLBACK_URL
                                 },
                                 headers: {
                                   'Accept' => 'application/json'
                                 })
        session['access_token'] = response['access_token']
        @@user_info_response = HTTParty.get("https://api.github.com/user?access_token=#{session['access_token']}", headers: { 'User-Agent' => 'Rat Store Example' })

        session['username'] = @@user_info_response['login']
      end
      redirect to('/profile/edit')
    end

    get('/dash') do

      @user = JSON.parse($redis["profiles:#{session['username']}"])
      @profile = '/profile/' + "#{session['username']}"
      @user_city  = @user['user_city']
      @user_state = @user['user_state']

      # Ny Times Senate vote API
      time_base_url = 'http://api.nytimes.com/svc/politics/v3/us/legislative/congress/'
      time_chamber_senate = 'senate'
      times_date = '2014-04-03/2014-04-04'
      @time_url_senate = "http://api.nytimes.com/svc/politics/v3/us/legislative/congress/#{time_chamber_senate}/votes/#{times_date}.json?api-key=#{TIMES_API_KEY}"
      @times_senate = HTTParty.get(@time_url_senate)

      # Ny Times House Vote API
      time_chamber_house = 'house'
      @time_url_house = "http://api.nytimes.com/svc/politics/v3/us/legislative/congress/#{time_chamber_house}/votes/#{times_date}.json?api-key=#{TIMES_API_KEY}"
      @times_house = HTTParty.get(@time_url_house)

      # Twitter Api
      @tweets = []
      TWITTER_CLIENT.search('senate', result_type: 'recent').take(5).each do |tweet|
        @tweets.push(tweet.text)
      end

      # Weather API
      wunderground_base = 'http://api.wunderground.com/api/'
      wunderground_state = 'NY'
      wunderground_city = 'Brooklyn'
      @wunderground_url = "#{wunderground_base}#{WUNDERGROUND_API_KEY}/forecast10day/q/#{wunderground_state}/#{wunderground_city}.json"
      @wunderground_response = HTTParty.get(@wunderground_url)

      # Yahoo finance API
      @data = YahooFinance.quotes(['GOOG', 'AAPL', 'F', 'CMCSK', 'MSFT', 'YHOO', '%5EGSPC', '%5EIXIC', 'BAC', 'EBAY', 'SIRI', 'TWTR'], [:last_trade_price, :change])
      # Github address for yahoo finance gem -- "https://github.com/herval/yahoo-finance/blob/master/README.md"
      # @anchors = @@anchors
      render(:erb, :dash, template: :layout)
    end

    get('/profile/edit') do
      render(:erb, :"anchor_profile/new", template: :layout)
    end

    post('/profile/new') do
      profile_info = {
        username: params[:username],
        email: params[:user_email],
        user_city: params[:user_city],
        user_state: params[:user_state],
        user_img: params[:user_img],
        house_bills: params[:house_bills],
        senate_bills: params[:senate_bills],
        top_stocks: params[:top_stocks],
        twitter: params[:twitter],
        weather: params[:weather]

      }

      @@profiles.push(profile_info)

      @@profiles.each do |profile|
        $redis.set("profiles:#{session['username']}", profile.to_json)
      end

      logger.info @@profiles
      redirect to('/dash')
    end

    get('/profiles') do
      @profiles = @@profiles
      render(:erb, :profiles, template: :layout)
    end

    get('/profile/:id') do
      @user = JSON.parse($redis["profiles:#{session['username']}"])
      params[:id] = @user['username']
      @user_info_response == @@user_info_response
      render(:erb, :user_profile, template: :layout)
    end

    get('/logout') do
      session[:access_token] = nil
      redirect to('/bye')
    end

    get '/bye' do
    render(:erb, :bye, template: :layout)
  end
end
