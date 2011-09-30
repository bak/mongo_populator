require "spec_helper"

describe MongoPopulator::MongoArray do
  it 'should basically be an array' do
    ma = MongoPopulator::MongoArray.new
    ma.should be_a(Array)
    MongoPopulator::MongoArray.methods.count.should equal Array.methods.count
  end
end
