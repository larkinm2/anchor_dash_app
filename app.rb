require 'sinatra/base'
require 'httparty'
require 'pry'
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
      API_KEY = "13a4a6374ae75f76bb9b710c22d043cb:3:69767050"
    end

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
      time_base_url = "http://api.nytimes.com/svc/politics/3/us/legislative/congress/"
      time_chamber_senate = "senate"
      times_date = "2014-04-03/2014-04-04"
      @time_url_senate = "http://api.nytimes.com/svc/politics/v3/us/legislative/congress/#{time_chamber_senate}/votes/#{times_date}.json?api-key=#{API_KEY}"
      @times_senate = HTTParty.get(@time_url_senate)

      time_chamber_house = "house"
      @time_url_house = "http://api.nytimes.com/svc/politics/v3/us/legislative/congress/#{time_chamber_house}/votes/#{times_date}.json?api-key=#{API_KEY}"
      @times_house = HTTParty.get(@time_url_house)

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

