require 'active_record'

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
