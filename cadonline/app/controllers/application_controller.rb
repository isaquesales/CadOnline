class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :set_sidebar_collections

  private

  def set_sidebar_collections
    return unless logged_in?

    @sidebar_documents = current_user.documents.where(archived: false).order(updated_at: :desc).limit(25)
    @sidebar_favorites = current_user.favorite_documents.where(archived: false).order("favorites.updated_at DESC").limit(25)
  end
end
