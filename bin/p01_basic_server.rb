require 'rack'
require 'byebug'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  message = req.path
  res = Rack::Response.new
  # byebug
  res['Content-Type'] = 'text/html'
  res.write(message)
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
