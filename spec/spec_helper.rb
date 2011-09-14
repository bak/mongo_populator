require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require 'mongo'
require 'mongo_populator'

RSpec.configure do |config|
  config.mock_with :mocha

  begin
    $db = Mongo::Connection.new("localhost", 27017).db("test-db")    
  rescue Mongo::ConnectionFailure
    p "Could not connect to Mongo. Ensure that db server is running at localhost port 27017."
  end
end
