require 'sinatra/base'
require 'httparty'
require 'securerandom'
require 'twitter'
require 'yahoo_finance'
require 'uri'
require 'json'
require 'securerandom'

uri = URI.parse(ENV['REDISTOGO_URL'])
$redis = Redis.new(host: uri.host,
                   port: uri.port,
                   password: uri.password)
