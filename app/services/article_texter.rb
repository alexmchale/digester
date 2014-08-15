class ArticleTexter

  attr_reader :article, :url

  def initialize(article)
    @article = article
    @url     = article.url
  end

  def pismo
    @pismo ||= Pismo::Document.new(url)
  end

  def title
    pismo.titles.inject("") do |title1, title2|
      if title1.length > title2.length
        title1
      else
        title2
      end
    end
  end

  def author
    if pismo.authors.present?
      pismo.authors.join(", ")
    end
  end

  def body
    pismo.body
  end

  def published_at
    pismo.datetime
  end

end
