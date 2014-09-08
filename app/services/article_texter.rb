class ArticleTexter

  attr_reader :article, :data

  def initialize(article)
    @article = article
    @data    = [ article.raw_html, article.url ].find(&:present?)
  end

  def pismo
    @pismo ||= Pismo::Document.new(data)
  end

  def title
    pismo.titles.compact.inject("") do |title1, title2|
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
