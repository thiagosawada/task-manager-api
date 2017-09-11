# Eu criei este arquivo

require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  # Quando eu tava testando o model, eu usei build em vez de create porque eu não quero testar uma instância em memória, mas sim uma requisição ao banco de dados.
  # O create cria um objeto e salva no banco de dados.
  let!(:user) { create(:user) }

  # Ao contrário do build, o create gera um id
  let(:user_id) { user.id }

  # Pra passar o teste, cujo domínio começa com api
  before { host! 'api.taskmanager.dev' }

  describe 'GET /users/:id' do

    # Preparar o cenário para o teste
    before do
      # Especificar a versão da API
      headers = { 'Accept' => 'application/vnd.taskmanager.v1'}

      # O segundo parâmetro é o body e o terceiro é o header. O body está vazio.
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when user exists' do
      it 'returns the user' do
        user_response = JSON.parse(response.body) # Transforma em um hash
        expect(user_response['id']).to eq(user_id)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

    end

    context 'when the user does not exist' do

      # Sobrescrever o user_id
      let(:user_id) { 10000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /users' do

    before do
      headers = { 'Accept' => 'application/vnd.taskmanager.v1' }
      post '/users', params: { user: user_params }, headers: headers
    end

    context 'when the request params are valid' do

      # FactoryGirl.attributes_for retorna um hash com os atributos definidos em /factories/users.rb
      let(:user_params) { attributes_for(:user) }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)

      end

      it 'returns json data for the created user' do
        user_response = JSON.parse(response.body)
        expect(user_response['email']).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      # O FactoryGirl permite sobrescrever qualquer atributo
      let(:user_params) { attributes_for(:user, email: 'invalid_email@') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        user_response = JSON.parse(response.body)
        expect(user_response).to have_key('errors')
      end
    end
  end

end
