# Eu criei este arquivo

require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  # Quando eu tava testando o model, eu usei build em vez de create porque eu não quero testar uma instância em memória, mas sim uma requisição ao banco de dados.
  # O create cria um objeto e salva no banco de dados.
  let!(:user) { create(:user) }

  # Ao contrário do build, o create gera um id
  let(:user_id) { user.id }

  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',

      # Mime é um módulo pra identificar um tipo de dado
      'Content-Type' => Mime[:json].to_s # Retorna "application/json"
    }
  end

  # Pra passar o teste, cujo domínio começa com api
  before { host! 'api.taskmanager.dev' }

  describe 'GET /users/:id' do

    # Preparar o cenário para o teste
    before do
      # Especificar a versão da API
      # headers = { 'Accept' => 'application/vnd.taskmanager.v1'} # Foi comentado na refatoração

      # O segundo parâmetro é o body e o terceiro é o header. O body está vazio.
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when user exists' do
      it 'returns the user' do
        # symbolize_names: true faz com que as chaves da requisição sejam convertidas de string para symbol
        # user_response = JSON.parse(response.body, symbolize_names: true) # Transforma em um hash
        # expect(user_response[:id]).to eq(user_id) # Antes do 'symbolize_names: true' era user_response['id']
        # As linhas acima foram comentadas na refatoração

        # json_body vem do module
        expect(json_body[:id]).to eq(user_id)
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
      # to_json. Precisa converter pra json porque defini o content-type em headers
      post '/users', params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do

      # FactoryGirl.attributes_for retorna um hash com os atributos definidos em /factories/users.rb
      let(:user_params) { attributes_for(:user) }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns json data for the created user' do
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      # O FactoryGirl permite sobrescrever qualquer atributo
      let(:user_params) { attributes_for(:user, email: 'invalid_email@') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /users/:id' do

    before do
      put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) do { email: 'new_email@taskmanager.com'}
      end

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json data for the updated user' do
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) do { email: 'invalid_email@'}
      end

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before do
      delete "/users/#{user_id}", params: {}, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      # Se usasse o find, retornaria um erro em vez de nil
      expect(User.find_by(id: user.id)).to be_nil
    end

  end

end
