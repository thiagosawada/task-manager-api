# Eu criei este arquivo
require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  # Para o teste ter acesso ao namespace da API
  before { host! 'api.taskmanager.dev' }
  # Cria o usuário através do FactoryGirl
  let(:user) { create(:user) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'POST /sessions' do

    # Vai ser executado antes de cada 'it'
    before do
      post '/sessions', params: { session: credentials }.to_json, headers: headers
    end

    context 'when credentials are correct' do
      let(:credentials) do
        {
          email: user.email,
          password: '123456'
        }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json data for the user with auth token' do
        # É preciso recarregar o usuário porque o token muda a cada login
        user.reload
        expect(json_body[:auth_token]).to eq(user.auth_token)
      end
    end

    context 'when credentials are incorrect' do
      let(:credentials) do
        {
          email: user.email,
          password: 'invalid_password'
        }
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the errors' do
        # É preciso recarregar o usuário porque o token muda a cada login
        expect(json_body).to have_key(:errors)
      end
    end
  end

  # Sign out: expirar o token gerado, gerando outro token
  describe 'DELETE /sessions/:id' do
    let(:auth_token) { user.auth_token }

    before do
      delete "/sessions/#{auth_token}", params: {}, headers: headers
    end

    # 204 No content
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'changes the user auth token' do
      expect( User.find_by(auth_token: auth_token) ).to be_nil
    end


  end
end
