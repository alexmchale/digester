class Feed

  attr_reader :user, :title, :url, :description, :image_url, :language, :copyright, :subtitle, :author, :keywords, :owner

  def initialize(user)
    @user        = user
    @title       = "Feed for #{ user.email }"
    @url         = "http://example.com"
    @description = ""
    @image_url   = ""
    @language    = ""
    @copyright   = ""
    @subtitle    = ""
    @author      = user.email
    @keywords    = []
    @owner       = nil
  end

  def items
    []
  end

  def to_xml
    Podcastinator::Generator.new(self).to_xml
  end

end
