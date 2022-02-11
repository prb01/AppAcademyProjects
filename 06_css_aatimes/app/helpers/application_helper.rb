module ApplicationHelper
  def html_datetime_now
    time = Time.now.strftime('%FT%T%:z')
    time.html_safe
  end

  def print_datetime_now
    time = Time.now.strftime('%A, %B %e, %Y')
    time.html_safe
  end
end
