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
end
