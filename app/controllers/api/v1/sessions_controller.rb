class Api::V1::SessionsController < ApplicationController
  def create
    # find_by retorna ou nil ou o usuário. Não retorna uma exceção
    user = User.find_by(email: session_params[:email])

    # Precisa retornar um usuário (não pode ser nil).
    # valid_password? é um método do devise
    if user && user.valid_password?(session_params[:password])

      # sign_in é um helper do devise que loga o usuário no sistema. Mantém em registro no db que o usuário foi logado
      # store: false significa que eu não quero gravar nenhuma sessão pra esse usuário
      sign_in user, store: false

      # Gerar um novo token
      user.generate_authentication_token!
      user.save

      render json: user, status: 200
    else
      render json: { errors: 'Invalid password or email' }, status: 401
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token!
    user.save
    head 204
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
