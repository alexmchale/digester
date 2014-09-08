class User < ActiveRecord::Base

  ### Modules ###

  include BCrypt

  ### Constants ###

  ### Relations ###

  has_many :articles

  ### Scopes ###

  ### Validations ###

  validates :email, uniqueness: { case_sensitive: false }

  ### Callbacks ###

  before_validation :assign_default_image_url
  before_save :generate_secret_key

  ### Miscellaneous ###

  ### Instance Methods ###

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def email_md5
    Digest::MD5.hexdigest(email)
  end

  def assign_default_image_url
    return if feed_image_url.present?
    return if email.blank?
    self.feed_image_url = "http://www.gravatar.com/avatar/#{ email_md5 }.jpg?s=512&r=g&d=monsterid"
  end

  def generate_secret_key
    if secret_key.blank?
      self.secret_key = SecureRandom.urlsafe_base64(1024).gsub(/[^a-zA-Z0-9]/, "")[0, 32]
    end
    if bookmark_key.blank?
      self.bookmark_key = SecureRandom.urlsafe_base64(1024).gsub(/[^a-zA-Z0-9]/, "")[0, 32]
    end
    self
  end

  def generate_secret_key!
    self.secret_key = ""
    generate_secret_key
  end

  def instapaper
    if instapaper_token.present? && instapaper_token_secret.present?
      @instapaper ||= InstapaperClient.new(self)
    end
  end

  def add_article_bookmarklet(hostname, port)
    coffee_filename = Rails.root.join("app", "assets", "javascripts", "bookmarklet", "client.js.coffee")
    coffee_raw      = File.read(coffee_filename)
    js_raw          = CoffeeScript.compile(coffee_raw)
    js_uglified     = Uglifier.new.compile(js_raw)

    "javascript:#{ js_uglified }void(0)"
      .gsub("%%hostname%%", "#{ hostname }:#{ port }")
      .gsub("%%secret_key%%", self.bookmark_key)
  end

  ### Class Methods ###

end
