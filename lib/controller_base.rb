require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "already rendered!" if already_built_response?
    @res["Location"] = url
    @res.status = 302
    @already_built_response = true
    session
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "already rendered!" if already_built_response?
    @res.write(content)
    @res["Content-Type"] = content_type
    @already_built_response = true
    session
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    # Use the controller and template names to construct the path to a template file.
    # template_file = Not sure how to do to this...
    root = File.dirname(__FILE__)
    controller_name = self.class.to_s.underscore
    # Use File.read to read the template file.
    template_file = File.read("#{root}/../views/#{controller_name}/#{template_name}.html.erb")
    # Create a new ERB template from the contents.
    content = ERB.new(template_file).result(binding)
    # Evaluate the ERB template, using binding to capture the controller's instance variables.
    # Pass the result to render_content with a content_type of text/html.
    render_content(content, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
