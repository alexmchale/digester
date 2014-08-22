module ApplicationHelper

  def truncate_url(url, options = {})
    truncate(url.gsub(%r|^.*?://|, ""), options)
  end

end
