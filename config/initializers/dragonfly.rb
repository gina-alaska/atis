require 'dragonfly'

app = Dragonfly[:media]
app.configure_with(:imagemagick)
app.configure_with(:rails)

app.define_macro(ActiveRecord::Base, :image_accessor)
app.define_macro(ActiveRecord::Base, :file_accessor)
app.configure do |c|
  
end
