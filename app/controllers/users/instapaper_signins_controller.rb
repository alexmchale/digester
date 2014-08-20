class Users::InstapaperSigninsController < InheritedResourcesController

  actions :new, :create

  before_filter :get_user

  def new
    build_resource.user = @user

    super
  end

  def create
    build_resource.user = @user

    super
  end

  protected

  def get_user
    @user = User.find(params[:user_id])

    if @user == nil || @user != current_user
      redirect_to new_user_session_path
    end
  end

end
