class FeedItem

  attr_reader :article

  def initialize(article)
    @article = article
  end

  def title
    article.title
  end

  def author
    article.author
  end

  def url
    article.url
  end

  def image_url
    article.image_url
  end

  def published_at
    article.published_at
  end

  def subtitle
    ""
  end

  def image_url
    ""
  end

  def file_size
    article.mp3_file_size
  end

  def mime_type
    article.mp3_mime_type
  end

  def guid
    article.sha256
  end

  def time
    published_at || created_at || Time.now
  end

  def duration
    article.mp3_duration
  end

  def keywords
    []
  end

  def mp3_ready?
    sha256.present?
  end

  def to_feed_item

  end

end
