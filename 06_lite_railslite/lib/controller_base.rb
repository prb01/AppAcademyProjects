require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require 'securerandom'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params

  def self.protect_from_forgery
    @@protect_from_forgery = true
  end

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
    @already_built_response = false
  end

  def form_authenticity_token
    @token ||= SecureRandom.urlsafe_base64
    res.set_cookie('authenticity_token', { path: '/', value: @token })
    @token
  end

  def check_authenticity_token
    cookie_token = req.cookies['authenticity_token']
    unless cookie_token && params['authenticity_token'] == cookie_token
      puts "HELLO WE ALL UP IN HERE"
      raise "Invalid authenticity token"
    end
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Already built response you fool!" if already_built_response?
    res.status = 302
    res['Location'] = url
    session.store_session(res)
    flash.store_flash(res)
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Already built response you fool!" if already_built_response?
    res['Content-Type'] = content_type
    res.write(content)
    session.store_session(res)
    flash.store_flash(res)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = File.join(".","views",self.class.name.underscore,"#{template_name}.html.erb")
    file = File.open(path, mode="r")
    erb_template = ERB.new(file.read)
    file.close
    render_content(erb_template.result(binding), 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    if protect_from_forgery? && req.request_method != "GET"
      self.check_authenticity_token
    else
      self.form_authenticity_token
    end

    self.send(name)
    render(name) unless already_built_response?
  end

  private

  def protect_from_forgery?
    @@protect_from_forgery
  end
end

