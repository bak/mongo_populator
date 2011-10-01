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

  it "should not set an attribute if passed MongoPopulator.skip" do
    @collection.populate(1) do |record|
      record.monkey = MongoPopulator.skip
    end
    @collection.distinct('monkey').should be_empty
  end

  it "should set a NULL value if passed nil" do
    @collection.populate(1) do |record|
      record.monkey = nil
    end
    @collection.distinct('monkey').should_not be_empty
  end

  # TODO: there is a chance that this will legitimately fail (if 1 is always picked).
  it "should set an attribute only sometimes if MongoPopulator.skip is part of set" do
    @collection.populate(10) do |record|
      record.monkey = [1, MongoPopulator.skip]
    end
    count = 0; @collection.find().collect {|r| count += 1 if r.keys.include?('monkey')}
    count.should <= 9
  end

  context "when generating embedded documents" do
    before do
      @collection.populate(1) do |parent|
        parent.name = "Abraham"
        parent.kids = MongoPopulator.embed(30, {:name => ["River","Willow","Swan"], :age => (1..20), :tattoos => ["butterfly", MongoPopulator.skip]})
      end
    end

    it "should generate within the value provided" do
      @collection.find_one()['kids'].should have(30).items
    end

    it "should not set a field when value is MongoPopulator.skip" do
      # above, tattoos is set to MongoPopulator.skip approx 50% of the time
      count = 0; @collection.find_one()['kids'].collect {|r| count += 1 if r.keys.include?('tattoos')}
      count.should <= 29
    end
  end

  after(:each) do
    @collection.drop
  end
end
