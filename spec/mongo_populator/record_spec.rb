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

  it "should persist a dictionary as-is" do
    record = MongoPopulator::Record.new(@collection)
    record.info = MongoPopulator.dictionary(:name => "mongo", :type => "db")
    record.info[:name].should == "mongo"
  end

  it "should raise an error if trying to skip within #dictionary" do
    lambda { MongoPopulator.dictionary(:name => "mongo", :type => MongoPopulator.skip) }.should raise_error(StandardError)
  end

  it "should persist an array as-is" do
    record = MongoPopulator::Record.new(@collection)
    record.info = MongoPopulator.array("mongo", "db")
    record.info.should == ["mongo","db"]
  end

  it "should raise an error if trying to skip within #array" do
    lambda { MongoPopulator.array("mongo", MongoPopulator.skip) }.should raise_error(StandardError)
  end

  after(:each) do
    @collection.drop
  end
end
