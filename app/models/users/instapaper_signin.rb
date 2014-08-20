class Users::InstapaperSignin

  ### Modules ###

  include ActiveModel::Model

  ### Constants ###

  ### Relations ###

  ### Scopes ###

  ### Validations ###

  validates :user, presence: true
  validates :username, presence: true

  ### Callbacks ###

  ### Miscellaneous ###

  attr_accessor :user, :username, :password

  ### Instance Methods ###

  def save
    return nil unless valid?

    auth = Instapaper.access_token(username, password)

    if auth == nil || !auth.kind_of?(Hash)
      self.errors[:username] << "cannot connect to instapaper"
      return nil
    elsif auth.keys.sort != %w( oauth_token oauth_token_secret )
      self.errors[:username] << "invalid username or password"
      return nil
    else
      user.update_attributes!({
        :instapaper_token        => auth["oauth_token"],
        :instapaper_token_secret => auth["oauth_token_secret"],
      })
    end

    return self
  end

  ### Class Methods ###

end
