module ApplicationHelper
  def flashes
    output = ""
    flash.each do |type, message|
      output << "<div class=\"alert alert-#{type}\">"
      output << message
      output << content_tag(:a, '&times;'.html_safe, class: 'close', "data-dismiss"=>"alert")
      output << "</div>"
    end
    output.html_safe
  end
  
  def avatar_url(user, size=48)
    default_url = "mm"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{CGI.escape(default_url)}"
  end
end
