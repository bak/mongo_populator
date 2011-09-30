require "spec_helper"

describe MongoPopulator::MongoArray do
  it 'should basically be an array' do
    assert_true MongoArray.kind_of?(Array)
    assert_equal MongoArray.methods.count, Array.methods.count
  end
end
