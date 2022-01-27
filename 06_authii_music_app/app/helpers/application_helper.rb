module ApplicationHelper
  include ERB::Util

  def auth_token
    "<input type=\"hidden\"
      name=\"authenticity_token\"
      value=\"#{form_authenticity_token}\">".html_safe
  end

  def ugly_lyrics(lyrics)
    "♫ #{html_escape(lyrics).split("\r\n").join("<br>♫ ")}".html_safe
  end
end
