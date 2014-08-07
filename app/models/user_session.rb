class UserSession

  include ActiveModel::Model

  attr_accessor :email, :password
  attr_reader :user

  def save
    user = User.where("LOWER(email) = LOWER(?)", email).first

    if user != nil && user.password == password
      @user = user
      true
    else
      errors.add(:base, "invalid email or password")
      false
    end
  end

end
