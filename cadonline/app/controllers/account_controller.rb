class AccountController < ApplicationController
  before_action :require_login!

  def show; end

  def destroy_data
    current_user.privacy_requests.create!(request_type: "delete_my_data", status: "done", notes: "Auto-atendimento")
    current_user.destroy!
    sign_out!
    redirect_to signup_path, notice: "Seus dados foram removidos."
  end
end
