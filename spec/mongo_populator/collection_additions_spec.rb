require "spec_helper"

describe MongoPopulator::CollectionAdditions do
  before(:each) do
    @collection = $db.collection('test-collection')
  end

  it "should add populate method to collection class" do
    @collection.should respond_to(:populate)
  end

  it "should add 10 records to database" do
    @collection.populate(10)
    @collection.count.should == 10
  end

  it "should set attribute columns" do
    @collection.populate(1) do |record|
      record.name = "foo"
    end
    @collection.distinct('name').last.should == "foo"
  end

  after(:each) do
    @collection.drop
  end
end
