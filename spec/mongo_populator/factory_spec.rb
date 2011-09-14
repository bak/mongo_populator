require "spec_helper"

describe MongoPopulator::Factory do
  before(:each) do
    @collection = $db.collection('test-collection')
    @factory = MongoPopulator::Factory.for_collection(@collection)
  end

  it "should generate within range" do
    @factory.populate(2..4)
    @collection.count.should >= 2
    @collection.count.should <= 4
  end

  after(:each) do
    @collection.drop
  end
end
