require 'debug'
require 'httparty'
require 'json'

class PokemonClient
  include HTTParty
  base_uri 'https://pokeapi.co/api/v2'

  def initialize
    @pokemon = true
  end

  # @req Rack::Request
  def process_request(req)
    case req.request_method
    when 'GET'
      return 200, { 'content-type' => 'json' }, get_pokemon(req.params['pokemon']).body
    when 'POST'
      return 400, { 'method-not-supported' => 'true' }, "Post not supported, body: #{JSON.parse(req.body.read)}"
    else
      return 400, { 'invalid-method' => 'true' }, "Invalid Method #{req.request_method} for /pokemon"
    end
  end

  private
  def get(path)
    self.class.get(path)
  end

  def get_pokemon(mon)
    get("/pokemon/#{mon}")
  end
end

run do |env|
  req = Rack::Request.new(env)

  case req.path_info
  when '/pokemon'
    status_code, headers, body = PokemonClient.new.process_request(req)
    [status_code, headers, [ body ]]
  else
    [400, { 'invalid-path' => 'true' }, [ "Invalid Path #{req.path_info}" ]]
  end
end
