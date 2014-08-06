json.array!(@articles) do |article|
  json.extract! article, :id, :url, :body
  json.url article_url(article, format: :json)
end
