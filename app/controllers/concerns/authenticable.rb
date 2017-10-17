# Criei este arquivo
# Este módulo será incluído em application_controller
module Authenticable
  def current_user
    # ||= é uma boa prática pois ele pesquisa o current user apenas uma vez
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end
end
