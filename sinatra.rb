require 'sinatra'
require 'json'
require 'debug'

before do
  content_type 'application/json'
end

# Add your code here

post '/users' do
  payload = nil
  begin
    payload = JSON.parse(request.body.read)
  rescue JSON::ParserError
    return [ 400, {}, [ "Invalid JSON" ] ]
  end

  name = payload["name"]
  age = payload["age"]
  if name.nil? || age.nil?
    return [ 400, {}, [ "Missing required params name || age" ] ]
  end

  if name.length == 0
    return [ 400, {}, [ "name cannot be blank" ] ]
  end

  if name.length > 32
    return [ 400, {}, [ "name too long" ]]
  end

  begin
    age = Integer(age)
  rescue ArgumentError
    return [ 400, {}, [ "age must be a valid integer" ] ]
  end

  if age < 16
    return [ 400, {}, [ "age must be greater than 16" ] ]
  end

  # u = User.save(name: name, age: age)
  # puts u.to_json

  [201, { "Content-Type": "application/json" }, [ '{ "user": { "age": 5, "name": "john" } }' ]]
end

