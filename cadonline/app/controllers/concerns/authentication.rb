module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?
  end

  private

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_login!
    return if logged_in?

    redirect_to login_path, alert: "Faça login para continuar."
  end

  def sign_in!(user)
    reset_session
    session[:user_id] = user.id
    user.update_column(:last_sign_in_at, Time.current)
  end

  def sign_out!
    reset_session
  end
end
