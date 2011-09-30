require "spec_helper"

describe MongoPopulator::MongoDictionary do
  it 'should basically be a hash' do
    md = MongoPopulator::MongoDictionary.new
    md.should be_a(Hash)
    MongoPopulator::MongoDictionary.methods.count.should equal Hash.methods.count
  end
end
