class SessionsController < ApplicationController
  skip_before_action :set_sidebar_collections

  def new; end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)
    if user&.authenticate(params[:password])
      sign_in!(user)
      redirect_to root_path, notice: "Login realizado com sucesso."
    else
      flash.now[:alert] = "E-mail ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out!
    redirect_to login_path, notice: "Sessão encerrada."
  end
end
