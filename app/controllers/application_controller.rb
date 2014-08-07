class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user=(user)
    session[:user_id] = user.try(:id)
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  helper_method :current_user

  def self.check_signed_in!
    before_filter :check_signed_in!
  end

  def check_signed_in!
    if self.current_user == nil
      redirect_to new_user_session_path
    end
  end

end
