class User < ActiveRecord::Base

  validates :email, uniqueness: { case_sensitive: false }

  before_save :generate_secret_key

  include BCrypt

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

end
