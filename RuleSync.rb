require 'yaml'
require 'redis'
require 'mysql2'
require 'activerecord-mysql2-adapter'

config = YAML::load_file("config/database.yml")["development"]
config["host"] = config["hostname"]

mysqlclient = Mysql2::Client.new(config)

redis = Redis.new
key = ""
value = Array.new
value = []
language = ARGV.first.to_s
mysqlclient.query("SELECT * FROM languages  WHERE languages.name='#{language}'").each do |row|
	printf "!!Loading rules for %s!!\n\n", row["name"]
	key = row["name"]
	mysqlclient.query("SELECT * FROM rules  WHERE rules.language_id=#{row["id"]}").each do |row|
		puts row["expression"]
		value.push(row["expression"].to_s)
	end
end

redis.set(key,value)
puts "\n\n!!Currently on redis!!\n\n"
puts redis.get(key)
