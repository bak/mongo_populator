require "spec_helper"

describe MongoPopulator::Random do
  it "should pick a random number in range excluding last value" do
    MongoPopulator.stubs(:rand).with(5).returns(3)
    MongoPopulator.value_in_range(10...15).should == 13
  end

  it "should pick a random number in range including last value" do
    MongoPopulator.stubs(:rand).with(5).returns(3)
    MongoPopulator.value_in_range(10..14).should == 13
  end

  it "should pick a random time in range" do
    start_time = Time.now - 172800
    end_time = Time.now
    MongoPopulator.stubs(:rand).with(end_time.to_i-start_time.to_i).returns(1)
    MongoPopulator.value_in_range(start_time...end_time).should == Time.at(start_time.to_i + 1)
  end

  it "should pick a random date in range" do
    start_date = Date.today - 63072000 
    end_date = Date.today
    MongoPopulator.stubs(:rand).with(end_date.jd-start_date.jd).returns(1)
    MongoPopulator.value_in_range(start_date...end_date).should == Date.jd(start_date.jd + 1)
  end

  it "should pick a random string by converting to array" do
    MongoPopulator.stubs(:rand).with(5).returns(2)
    MongoPopulator.value_in_range('a'..'e').should == 'c'
  end

  it "should pick 3 random words" do
    MongoPopulator.words(3).split.should have(3).records
  end

  it "should pick a random number of random words" do
    MongoPopulator.stubs(:rand).returns(3)
    MongoPopulator.words(10...15).split.should have(13).records
  end

  it "should generate 3 random sentences" do
    MongoPopulator.sentences(3).split(/\. [A-Z]/).should have(3).records
  end

  it "should generate 3 random paragraphs" do
    MongoPopulator.paragraphs(3).split(/\n\n/).should have(3).records
  end

  it "should generate an array of requested size from set" do
    MongoPopulator.items(5..7, %w(a b c d e f g h i j k)).should have_at_least(5).records
  end

  it "should raise an error if trying to skip within #items" do
    lambda { MongoPopulator.items(2, ['money','cash',MongoPopulator.skip]) }.should raise_error(StandardError)
  end
  
  it "should generate a unique array" do 
    res = [ ]
    100.times do # we can be reasonably certain...
      set = MongoPopulator.items(3, %w(a b c d)) 
      res << (set == set.uniq)
    end
    res.should_not include(false)
  end

  context "when the set is not large enough to accomodate a uniq array of the size requested" do
    before do
      @set = MongoPopulator.items(4..5, %w(a b c))
    end 
    
    it "should generate a smaller array than asked for" do
      @set.size.should == 3
    end
    
    it "should still be unique" do
      @set.should include("a","b","c")
    end
  end
end
