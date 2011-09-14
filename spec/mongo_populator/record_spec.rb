require "spec_helper"

describe MongoPopulator::Record do
  before(:each) do
    @collection = $db.collection('test-collection')
  end

  it "should pick random number from range" do
    record = MongoPopulator::Record.new(@collection)
    record.stock = 2..5
    record.stock.should >= 2
    record.stock.should <= 5
  end

  it "should pick random value from array" do
    record = MongoPopulator::Record.new(@collection)
    record.name = %w[foo bar]
    %w[foo bar].should include(record.name)
  end

  it "should allow set via attributes hash" do
    record = MongoPopulator::Record.new(@collection)
    record.attributes = {:stock => 2..5}
    record.stock.should >= 2
    record.stock.should <= 5
  end

  it "should take a proc object via attributes hash" do
    record = MongoPopulator::Record.new(@collection)
    record.attributes = {:stock => lambda {15}}
    record.stock.should == 15
  end

  after(:each) do
    @collection.drop
  end
end
