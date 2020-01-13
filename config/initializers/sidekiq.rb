Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
  config.average_scheduled_poll_interval = 15
end
