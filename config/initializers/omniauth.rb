Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, MasterTable::Twitter::CONSUMER_KEY, MasterTable::Twitter::CONSUMER_SECRET
end