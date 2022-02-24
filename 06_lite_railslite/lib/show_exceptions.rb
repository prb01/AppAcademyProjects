require 'erb'
require 'byebug'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)
    rescue => e
      render_exception(e)
    end
  end

  private

  def render_exception(e)
    path = File.join(".","lib","templates","rescue.html.erb")
    file = File.open(path, mode="r")
    erb_template = ERB.new(file.read)
    file.close

    ['500', {'Content-type' => 'text/html'}, [erb_template.result(binding)]]
  end

  def source_file(e)
    e.backtrace.first.split(":")[0]
  end

  def source_line(e)
    e.backtrace.first.split(":")[1]
  end

  def lines_to_extract(e)
    line_num = source_line(e).to_i
    delta = 5
    line_nums = [line_num - delta, delta * 2]
  end

  def source_code(e)
    result = []
    line_nums = lines_to_extract(e)
    file = File.open(source_file(e), mode='r')

    line_nums[0].times{ file.gets }
    line_nums[1].times{ |i| result << "#{line_nums[0] + i + 1} #{file.gets}" }

    file.close

    result
  end

end
