class ArticlesController < InheritedResourcesController

  check_signed_in!

  protected

  def permitted_params
    params.permit(:article => %i(
      url
    ))
  end

  def end_of_association_chain_with_user
    end_of_association_chain_without_user.where(user_id: current_user.id)
  end
  alias_method_chain :end_of_association_chain, :user

end
