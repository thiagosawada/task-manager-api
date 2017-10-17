# Criei este arquivo
require 'rails_helper'

RSpec.describe Authenticable do
  # Simular um controller que vai incluir o módulo Authenticable para que o teste não se repita pra cada controller já existente
  controller(ApplicationController) do
  # Este controller só existe pra fazer o teste e herda de ApplicationController
    include Authenticable # Este é o módulo que quero testar

  end

  let(:app_controller) { subject } # Neste caso, subject é uma instância do controller

  describe '#current_user' do
    let(:user) { create(:user) }

    before do
      # O método double cria um objeto anônimo com qualquer método
      req = double(:headers => { 'Authorization' => user.auth_token })
      # req.headers['Authorization'] vai retornar user.auth_token

      # Modificando o objeto para retornar o req em vez de request
      allow(app_controller).to receive(:request).and_return(req)

    end

    it 'returns the user from the authorization header' do
      expect(app_controller.current_user).to eq(user)
    end
  end
end
