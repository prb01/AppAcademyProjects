require 'json'

class Flash
  attr_reader :cookie, :flash
  attr_accessor :now

  def initialize(req)
    @cookie = req.cookies['_rails_lite_app_flash'] ? JSON.parse(req.cookies['_rails_lite_app_flash']) : {}
    @flash = {}
    @now = {}
  end

  def flashed?
    @cookie['flash'] ? true : false
  end

  def [](key)
    combined_flash = now.merge(cookie).merge(flash)
    combined_flash.transform_keys! {|k| k.to_s } 
    combined_flash[key.to_s]
  end

  def []=(key, val)
    @flash[key.to_s] = val
  end
  
  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', { path: '/', 'max-age' => 0, value: @flash.to_json })
  end
end
