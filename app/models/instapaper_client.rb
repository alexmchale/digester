class InstapaperClient

  attr_reader :user, :instapaper

  def initialize(user)
    @user = user

    @instapaper =
      Instapaper::Client.new({
        :oauth_token        => user.instapaper_token,
        :oauth_token_secret => user.instapaper_token_secret,
      })
  end

  def bookmarks
    instapaper.bookmarks
  end

end
