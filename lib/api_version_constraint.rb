class ApiVersionConstraint

  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(request)
    # https://en.wikipedia.org/wiki/List_of_HTTP_header_fields

    @default || request.headers['Accept'].include?("application/vnd.taskmanager.v#{@version}")
  end


end
