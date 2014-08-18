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

  before_validation :get_instapaper_token
  before_save :generate_secret_key

  ### Miscellaneous ###

  attr_accessor :instapaper_username, :instapaper_password

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

  def get_instapaper_token
    return if instapaper_username.blank? && instapaper_password.blank?

    auth = Instapaper.access_token(instapaper_username, instapaper_password)

    if auth == nil || !auth.kind_of?(Hash)
      self.errors[:instapaper_username] << "cannot connect to instapaper"
    elsif auth.keys.sort != %w( oauth_token oauth_token_secret )
      self.errors[:instapaper_username] << "invalid username or password"
    else
      self.instapaper_token        = auth["oauth_token"]
      self.instapaper_token_secret = auth["oauth_token_secret"]
    end
  end

  ### Class Methods ###

end
