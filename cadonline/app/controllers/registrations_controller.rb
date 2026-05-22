class RegistrationsController < ApplicationController
  skip_before_action :set_sidebar_collections

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.accepted_terms_at = Time.current if ActiveModel::Type::Boolean.new.cast(user_params[:accepted_terms])

    if @user.save
      sign_in!(@user)
      redirect_to root_path, notice: "Conta criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :accepted_terms)
  end
end
