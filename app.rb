require 'sinatra/base'
require 'httparty'
require 'pry'
require 'securerandom'
require "twitter"

class App < Sinatra::Base

  ########################
  # Configuration
  ########################

    configure do
      enable :logging
      enable :method_override
      enable :sessions
      @@anchors = []
      TIMES_API_KEY = "13a4a6374ae75f76bb9b710c22d043cb:3:69767050"
      TWITTER_API_KEY = "2MtCWbofOSqVAeA2umSVeW6qB"
    #   twitter = {:consumer_key    => "2MtCWbofOSqVAeA2umSVeW6qB",
    #   :consumer_secret => "A77U8WxMwiWgo6ruJHDtdVLOtsYSlvbO1TdIwQY2FchejC4Cjw"
    #     }

    #   client = Twitter::REST::Client.new(config)
    # end
      WUNDERGROUND_API_KEY = "1a6e6fc49fe9c3f3"


    before do
      logger.info "Request Headers: #{headers}"
      logger.warn "Params: #{params}"
    end

    after do
      logger.info "Response Headers: #{response.headers}"
    end

  ########################
  # Routes
  ########################

    get('/') do
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

      # twitter_base_url = "https://api.twitter.com/1.1/search/tweets.json?"
      # twitter_q = "senate"
      # @twitter_url = "#{twitter_base_url}q=#{twitter_q}"
      # @twitter = HTTParty.get(@twitter_url)

      #Weather API
      wunderground_base = "http://api.wunderground.com/api/"
      wunderground_state = "NY"
      wunderground_city = "Brooklyn"
      @wunderground_url = "#{wunderground_base}#{WUNDERGROUND_API_KEY}/forecast10day/q/#{wunderground_state}/#{wunderground_city}.json"
      @wunderground_response = HTTParty.get(@wunderground_url)
      render(:erb, :index)
    end



    get('/dash') do
      @anchors = @@anchors
      render(:erb, :dash)
    end


    get('/editor') do
      render(:erb, :editor)
    end

    get('/dash') do
      @anchors = @@anchors
      render(:erb, :dash)
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

  #redirect to('/contact?sent=true')
end
end

