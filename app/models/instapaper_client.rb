class InstapaperClient

  include ActionView::Helpers::SanitizeHelper

  attr_reader :user, :instapaper

  def initialize(user)
    @user = user

    @instapaper =
      Instapaper::Client.new({
        :oauth_token        => user.instapaper_token,
        :oauth_token_secret => user.instapaper_token_secret,
      })
  end

  def bookmarks(have: "")
    instapaper.bookmarks(have: have)
  end

  def bookmark_html(bookmark_id)
    instapaper
      .get_text(bookmark_id)
      .try(:force_encoding, "UTF-8")
      .try(:scrub, "?")
  end

  def bookmark_text(bookmark_id)
    strip_tags(bookmark_html(bookmark_id))
  end

end
