#!/usr/bin/env ruby

require 'erb'
require 'goliath'
require 'em-synchrony/activerecord'
require 'yajl'

# require 'activerecord'
require 'uri'

# db = URI.parse(ENV['DATABASE_URL'] || 'http://localhost')
environment = ENV['DATABASE_URL'] ? 'production' : 'development'
db = YAML.load(ERB.new(File.read('config/database.yml')).result)[environment]
ActiveRecord::Base.establish_connection(db)


# if db.scheme == 'postgres'
#   ActiveRecord::Base.establish_connection(
#     :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
#     :host     => db.host,
#     :username => db.user,
#     :password => db.password,
#     :database => db.path[1..-1],
#     :encoding => 'utf8'
#   )
# else
#   db = YAML.load(ERB.new(File.read('config/database.yml')).result)['development']
#   ActiveRecord::Base.establish_connection(db)
# end

class User < ActiveRecord::Base
end

class HelloWorld < Goliath::API
  def response(env)
    page = ERB.new(File.read('template.erb')).result
    [200, {}, page]
  end
end

class PostHelloWorld < Goliath::API
  use Goliath::Rack::Params

  def response(env)
    user = User.find(params['id'])
    [200, {}, "hello post world! #{params}, #{user.first_name}"]
  end
end

class RackRoutes < Goliath::API
  get  "/hello_world", HelloWorld
  post "/hello_world", PostHelloWorld
end
