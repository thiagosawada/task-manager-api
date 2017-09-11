class Api::V1::UsersController < ApplicationController
  respond_to :json

  def show
    # Forma de tratar exceções
    # Se o código dentro de begin der erro, ele executa o código em rescue
    begin
      @user = User.find(params[:id])
      respond_with @user
    rescue
      head 404
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: 201
    else
      # user.errors se refere aos erros identificados pelo devise
      render json: { errors: user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
