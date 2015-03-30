Rails.application.config.middleware.use OmniAuth::Builder do
  # Extract this config info into a better location.
  provider :harvest, Settings.harvest.oauth_id, Settings.harvest.oauth_secret
end