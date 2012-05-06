require 'active_record'
db = URI.parse(ENV['DATABASE_URL'])
ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

desc 'create a database'
task :create_db do
  ActiveRecord::Schema.define(:version => 0) do
    create_table "users", :force => true do |t|
      t.string   "first_name"
      t.datetime "created_at",                            :null => false
      t.datetime "updated_at",                            :null => false
    end
  end
end
