Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Namespace cria um prefixo na URL (www.site.com/api)

  # Configurações defaults:
  # Tipos de midia - todas as requisições aos controllers dentro do namespace api serão no formato json

  # Configurações constraints
  # Para acessar os controles é preciso passar o subdomínio api. Com isso, a URL passa a ser api.site.com/api/

  # O path: "/" elimina o caminho o /api. Agora fica api.site.com

  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: "/" do

  end
end
