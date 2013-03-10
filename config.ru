require './okkake'
use Rack::Static, :urls => ["/js","/css", "/img"]   
run Okkake
