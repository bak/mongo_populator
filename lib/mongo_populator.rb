$:.unshift(File.dirname(__FILE__))

require 'mongo'
require 'mongo_populator/collection_additions'
require 'mongo_populator/factory'
require 'mongo_populator/record'
require 'mongo_populator/mongo_array'
require 'mongo_populator/mongo_dictionary'
require 'mongo_populator/mongo_skip'
require 'mongo_populator/random'

# MongoPopulator is made up of several parts. To start, see MongoPopulator::ModelAdditions.
module MongoPopulator
end
