require 'digest/md5'
require 'active_record'
require 'date'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection :development

class Account < ActiveRecord::Base
end


# User input from keyboard
trial_username = "nobunaga"
trial_passwd = "achichi-achicih"

# Search recorded info
begin
  a = Account.find(trial_username)
  db_username = a.id
  db_salt = a.salt
  db_hashed = a.hashed
  db_algo = a.algo
  db_lasttime = a.lasttime
rescue => e
  puts e.message
  exit(-1)
end

if db_algo == "1"
  trial_hashed = Digest::MD5.hexdigest(db_salt + trial_passwd)
else
  puts "Unknown algorithm is used for user #{trial_username}."
end

# Set timestamp
time = Time.now
zome = time.zone
time_int = time.to_i
puts "#{time_int}"
begin
  a = Account.find(trial_username)
  a.lasttime = time_int
rescue e
  puts e.message
  exit(-1)
end

# Display internal veriables
puts "--- DB ---"
puts "username = #{db_username}"
puts "salt = #{db_salt}"
puts "algorithm = #{db_algo}"
puts "hashed passwd = #{db_hashed}"
puts "timestamp = #{db_lasttime}"
puts "--- TRIAL ---"
puts "username = #{trial_username}"
puts "passed = #{trial_passwd}"
puts "hashed passwd = #{trial_hashed}"
puts "timestamp = #{time_int}"
puts ""

# Success?
if db_hashed == trial_hashed
  puts "Login Success"
else
  puts "Login Failure"
end
