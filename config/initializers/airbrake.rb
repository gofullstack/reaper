if ENV['AIRBRAKE_KEY']
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_KEY']
    config.development_environments = ['development']
  end
end
