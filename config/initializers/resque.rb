ENV["REDISTOGO_URL"] ||= "redis://codyduval:2455d4d4b5e32d4ecaab9c52974a9f71@panga.redistogo.com:9117/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

Dir["#{Rails.root}/app/workers/*.rb"].each { |file| require file }