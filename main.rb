require 'debug'
require 'webrick'
require 'json'
require 'cgi'

DO_BREAK = false

# req.body to get PUT/POST body
# req.header for headers
# req.path for path, i.e. /api/v1
# req.query_string for query params, i.e. /api/v1?schema_for=user -> "schema_for=user, then we need to CGI.unescape
#                                                                                      each query, splitting on &
# something like
# ```
# req.query_string.split('&').each do |q|
#   key, val = q.split('=', 2) # to support things like foo==, where the query strings value is `=`
#   case key
#   when 'age'
#     age = val.to_f
# end
# ```
class EEServer < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(req, res)
    binding.break if DO_BREAK == true

    res.status = 200
    res['Content-Type'] = 'application/json'
    res['Custom-Header-MAHMUD'] = 'true'
    res['lower-case-header-mahmud'] = 'true'
    res.body = { method: 'get' }.to_json
  end

  def do_POST(req, res)
    binding.break if DO_BREAK == true

    res.status = 201
    res['Content-Type'] = 'application/json'
    res.body = { method: 'post' }.to_json
  end

  def do_PUT(req, res)
    binding.break if DO_BREAK == true

    res.status = 201
    res['Content-Type'] = 'application/json'
    res.body = { method: 'put' }.to_json
  end
end

server = WEBrick::HTTPServer.new(Port: 9292)
server.mount('/api', EEServer)

trap 'INT' do server.shutdown end

server.start
