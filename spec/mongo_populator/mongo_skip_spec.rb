require "spec_helper"

describe MongoPopulator::MongoSkip do
  it 'should be instantiable' do
    mn = MongoPopulator::MongoSkip.new
    mn.should be_an_instance_of(MongoPopulator::MongoSkip)
  end
end
