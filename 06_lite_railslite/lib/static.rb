class Static
  attr_reader :app, :root, :pattern

  MIMES = {
    'jpg' => 'image/jpeg',
    'jpeg' => 'image/jpeg',
    'txt' => 'text/plain',
    'zip' => 'application/zip'
  }

  def initialize(app)
    @app = app
    @root = 'public'
    @pattern = Regexp.new("^/public(?<subpath>/\\D+|)/(?<filename>\\w+\.(?<ext>\\w{3,4}))$")
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path

    if matches?(path)
      params = get_path_params(path)
      render_asset(params)
    else
      app.call(env)
    end
  end

  private

  def render_asset(params)
    filename = get_filename(params)
    ext = get_extension(params)

    if File.exist?(filename)
      render_file(filename, ext)
    else
      render_error
    end
  end

  def matches?(path)
    pattern =~ path
  end

  def get_path_params(path)
    pattern.match(path).named_captures
  end

  def get_filename(params)
    File.join(root, params['subpath'], params['filename'])
  end

  def get_extension(params)
    MIMES[params['ext']]
  end

  def render_file(filename, ext)
    res = Rack::Response.new
    file = File.open(filename, mode='r')
    res.status = 200
    res['Content-type'] = ext

    res.write(file.read)
    file.close
    res.finish
  end

  def render_error
    res = Rack::Response.new
    res.status = 404
    res.write("File not found")
    res.finish
  end
end
