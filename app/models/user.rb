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

  def generate_secret_key
    return if secret_key.present?
    self.secret_key = SecureRandom.urlsafe_base64(1024).gsub(/[^a-zA-Z0-9]/, "")[0, 32]
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

  ### Class Methods ###

end
