require 'pages/community'

class Pages::Community::Register < Pages::Community
  register_signup_field         { div(:css => ".signup-field") }
end  