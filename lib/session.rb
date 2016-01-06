require 'json'
require 'byebug'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash .to_json
  def initialize(req)
    byebug
    cookies = req.cookies
    cookie = cookies["_rails_lite_app"]
    if cookie
      @cookie = JSON.parse(cookie)
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key.to_sym]
  end

  def []=(key, val)
    @cookie[key.to_sym] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie = @cookie.to_json
  end
end
