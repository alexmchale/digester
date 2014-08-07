class FeedsController < ApplicationController

  def show
    @user = User.where(secret_key: params[:id]).first

    if @user == nil
      redirect_to new_user_session_path
    else
      render xml: Feed.new(@user).to_xml
    end
  end

end
