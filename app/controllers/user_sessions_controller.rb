class UserSessionsController < InheritedResourcesController

  def create
    super do |success, failure|
      success.html do
        self.current_user = @user_session.user
        redirect_to articles_path
      end
    end
  end

end
