class UsersController < InheritedResourcesController

  def create
    super do |success, failure|
      success.html do
        self.current_user = @user
        redirect_to articles_path
      end
    end
  end

  protected

  def permitted_params
    params.permit(:user => %i(
      email
      password
    ))
  end

end
