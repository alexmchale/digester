class ArticlesController < InheritedResourcesController

  protected

  def permitted_params
    params.permit(:article => %i(
      url
    ))
  end

end
