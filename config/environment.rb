require 'sinatra'
require 'activerecord', '~> 5.2'
require 'sinatra-activerecord' 
require 'rake'
configure :development do
  ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)
end

configure :production do
  db = URI.parse(ENV['HEROKU_POSTGRESQL_PINK_URL'] || 'postgres://localhost/mydb')

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end