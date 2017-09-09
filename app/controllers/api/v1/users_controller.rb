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

end
