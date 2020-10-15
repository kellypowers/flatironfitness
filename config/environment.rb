
# ENV['SINATRA_ENV'] ||= "development"
# db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

# require 'bundler/setup'
# # Bundler.require(:default, ENV['SINATRA_ENV'])

# ActiveRecord::Base.establish_connection(
#   :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
#   # :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
#   :database => db.path[1..-1]
# )

# require_all 'app'


# configure :production do
#   db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

#   ActiveRecord::Base.establish_connection(
#     :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
#     :host     => db.host,
#     :username => db.user,
#     :password => db.password,
#     :database => db.path[1..-1],
#     :encoding => 'utf8'
#     )
# end

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