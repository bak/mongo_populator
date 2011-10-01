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

  it "should not set an attribute if passed nil" do
    @collection.populate(1) do |record|
      record.monkey = nil
    end
    @collection.distinct('monkey').should be_empty
  end

  # TODO: there is a chance that this will legitimately fail (if 1 is always picked).
  it "should set an attribute only sometimes if nil is part of set" do
    @collection.populate(10) do |record|
      record.monkey = [1, nil]
    end
    count = 0; @collection.find().collect {|r| count += 1 if r['monkey']}
    count.should <= 9
  end

  context "when generating embedded documents" do
    before do
      @collection.populate(1) do |parent|
        parent.name = "Abraham"
        parent.kids = MongoPopulator.embed(10..30, {:name => ["River","Willow","Swan"], :age => (1..20), :tattoos => ["butterfly", nil]})
      end
    end

    it "should generate within the value provided" do
      @collection.find_one()['kids'].should have_at_least(10).items
    end

    it "should follow the normal rules of population in evaluating the template"
  end

  after(:each) do
    @collection.drop
  end
end
