class InstapaperBookmarksController < ApplicationController

  def index
    @instapaper = InstapaperClient.new(current_user)
    @bookmarks  = @instapaper.bookmarks
  end

end
