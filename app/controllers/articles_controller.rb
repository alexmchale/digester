class ArticlesController < InheritedResourcesController

  check_signed_in!

  protected

  def permitted_params
    params.permit(:article => %i(
      url
    ))
  end

end
