module MongoPopulator
  module CollectionAdditions

    # Populate a Mongo::Collection with data
    def populate(amount, &block)
      Factory.for_collection(self).populate(amount, &block)
    end
  end
  
  # extend host class with class methods when we're included
  def self.included(host_class)
    host_class.extend(CollectionAdditions)
  end
end

Mongo::Collection.class_eval do
  include MongoPopulator::CollectionAdditions
end
