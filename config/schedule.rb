# Synchronize with Instapaper every 5 minutes.
every 5.minutes do
  runner "InstapaperSync.enqueue_all"
end
