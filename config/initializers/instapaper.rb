# Ensure that we've got a key and secret configured.
if ENV["INSTAPAPER_KEY"].blank? || ENV["INSTAPAPER_SECRET"].blank?
  raise "Instapaper integration needs to be configured in INSTAPAPER_KEY and INSTAPAPER_SECRET env vars."
end

# Configure Instapaper integration.
Instapaper.configure do |c|
  c.consumer_key    = ENV["INSTAPAPER_KEY"]
  c.consumer_secret = ENV["INSTAPAPER_SECRET"]
end
