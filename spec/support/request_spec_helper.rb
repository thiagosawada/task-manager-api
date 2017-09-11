# Eu criei este arquivo para definir métodos que vou usar nos meus testes

module RequestSpecHelper

  def json_body
    # ||= significa que o método vai retornar @json_body se houver um valor. Se ele estiver nulo, o código depois do = é executado.
    # Retorna o response.body convertido em um hash
    @json_body ||= JSON.parse(response.body, symbolize_names: true)
  end

end
