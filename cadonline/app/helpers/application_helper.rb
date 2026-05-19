module ApplicationHelper
  # Returns the initial theme of the HTML.
  # Future: session[:theme] || current_user.preferences[:theme] || "claro"
  def current_theme
    "claro"
  end
end
