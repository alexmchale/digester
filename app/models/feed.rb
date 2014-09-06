class Feed

  attr_reader :user, :title, :url, :description, :image_url, :language
  attr_reader :copyright, :subtitle, :author, :keywords, :owner

  def initialize(user)
    @user        = user
    @title       = user.feed_title
    @url         = "http://digester.io/feeds/#{ user.secret_key }"
    @description = user.feed_description
    @image_url   = user.feed_image_url
    @language    = ""
    @copyright   = ""
    @subtitle    = ""
    @author      = user.email
    @keywords    = []
    @owner       = nil
  end

  def items
    user
      .articles
      .mp3_published
      .order("created_at DESC")
      .to_a
      .select(&:mp3_ready?)
      .map { |article| FeedItem.new(article) }
  end

  def to_xml
    Podcastinator::Generator.new(self).to_xml
  end

end
