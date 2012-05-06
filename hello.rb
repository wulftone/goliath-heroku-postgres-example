#!/usr/bin/env ruby

require 'goliath'
require 'erb'
require 'uri'
require 'em-synchrony/activerecord'
require 'yajl'

db = URI.parse(ENV['DATABASE_URL'] || 'http://localhost')
if db.scheme == 'postgres' # This section makes Heroku work
  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
else # And this is for my local environment
  environment = ENV['DATABASE_URL'] ? 'production' : 'development'
  db = YAML.load(ERB.new(File.read('config/database.yml')).result)[environment]
  ActiveRecord::Base.establish_connection(db)
end

class User < ActiveRecord::Base
end

class HelloWorld < Goliath::API
  def response(env)
    page = ERB.new(File.read('template.erb')).result
    [200, {}, page]
  end
end

class CreateUser < Goliath::API
  def response(env)
    user = User.create(first_name: params['first_name'])
    [200, {}, user.first_name]
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
  post "/users", CreateUser
end
