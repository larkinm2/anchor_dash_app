class ApplicationController < Sinatra::Base
  configure do
    enable :logging
    enable :method_override
    enable :sessions
    @@profiles = []
    enable :logging
    enable :method_override
    enable :sessions
    uri = URI.parse(ENV['REDISTOGO_URL'])
    $redis = Redis.new(host: uri.host,
                       port: uri.port,
                       password: uri.password)
    $redis.flushdb
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end
end
