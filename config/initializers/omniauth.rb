Rails.application.config.middleware.use OmniAuth::Builder do

  provider :instapaper, ENV['INSTAPAPER_CONSUMER_KEY'], ENV['INSTAPAPER_CONSUMER_SECRET']

end
