require 'api_version_constraint' # Tá na pasta lib

Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Namespace cria um prefixo na URL (www.site.com/api)

  # Configurações defaults:
  # Tipos de midia - todas as requisições aos controllers dentro do namespace api serão no formato json

  # Configurações constraints
  # Para acessar os controles é preciso passar o subdomínio api. Com isso, a URL passa a ser api.site.com/api/

  # O path: "/" elimina o caminho o /api. Agora a URL fica assim: api.site.com

  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do

    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy]
    end
  end
end
