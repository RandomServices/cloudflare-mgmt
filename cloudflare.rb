require 'rubyflare'

connection = Rubyflare.connect_with(ENV['CLOUDFLARE_USERNAME'], ENV['CLOUDFLARE_API_KEY'])

zones = connection.get('zones')
