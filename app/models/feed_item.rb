class FeedItem

  attr_reader :article

  def initialize(article)
    @article = article
  end

  ## The method definitions below are used by Podcastinator to generate the feed.

  def title
    article.title
  end

  def author
    article.author
  end

  def url
    article.mp3_url
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
    "http://digester.io/articles/#{ article.id }"
  end

  def time
    published_at || created_at
  end

  def duration
    article.mp3_duration
  end

  def keywords
    []
  end

end
