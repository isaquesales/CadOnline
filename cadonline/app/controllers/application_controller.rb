class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :set_sidebar_collections
  before_action :set_security_headers

  private

  def set_sidebar_collections
    @sidebar_documents = []
    @sidebar_favorites = []
    return unless logged_in?

    @sidebar_documents = current_user.documents.where(archived: false).order(updated_at: :desc).limit(25).to_a
    @sidebar_favorites = current_user.favorite_documents.where(archived: false).order("favorites.updated_at DESC").limit(25).to_a
  end

  def set_security_headers
    response.set_header("X-Frame-Options", "SAMEORIGIN")
    response.set_header("X-Content-Type-Options", "nosniff")
    response.set_header("Referrer-Policy", "strict-origin-when-cross-origin")
    response.set_header("Permissions-Policy", "camera=(), microphone=(), geolocation=()")
  end
end
