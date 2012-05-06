#!/usr/bin/env ruby

require 'erb'
require 'goliath'
require 'em-synchrony/activerecord'
require 'yajl'

db =YAML.load(ERB.new(File.read('config/database.yml')).result)['development']
ActiveRecord::Base.establish_connection(db)

class User < ActiveRecord::Base
end

class HelloWorld < Goliath::API
  def response(env)
    page = "<h1>#{Goliath.env} hello world!</h1><form action='hello_world' method='post'>Id:<input type='text' name='id' /><input type='submit' /></form>"
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
