class OpenArticlesController < ApplicationController

  include ActionView::Helpers::SanitizeHelper

  respond_to :html, :json, :js

  skip_before_filter :verify_authenticity_token

  before_filter :user
  before_filter :article

  def new
  end

  def create
    if article.save
      redirect_to article
    else
      render :new
    end
  end

  private

  def user
    @user ||= User.find_by!(bookmark_key: params[:user_id])
  end

  def article
    @article ||=
      Article.new(permitted_params).tap do |article|
        sanitize_config = Sanitize::Config.merge(Sanitize::Config::RELAXED, remove_contents: true)

        raw_html = params.try(:[], :article).try(:[], :raw_html).try(:scrub)
        article.raw_html = Sanitize.document(raw_html, sanitize_config) if raw_html

        article.user = user
      end
  end

  def permitted_params
    params.permit(article: %i(
      url
      raw_html
    ))[:article]
  end

end
