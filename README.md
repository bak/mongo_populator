# MongoPopulator

`mongo_populator` populates a MongoDB database with placeholder data. It is built upon [`populator`](https://github.com/ryanb/populator) by Ryan Bates, but it works with the `mongo` gem in standalone scripts, and is not tied to any particular framework.

## Installation

    gem install mongo_populator

## Usage

This gem adds a "populate" method to a `Mongo::Collection`. Pass the number of documents you want to create along with a block. In the block you can set the field values for each document.

    require 'rubygems'
    require 'mongo_populator'

    db = Mongo::Connection.new("localhost", 27017).db("test-db")    
    
    article_collection = db.collection('articles')
    article_collection.populate(100) do |article|
      article.title       = MongoPopulator.words(4..6).capitalize
      article.slug        = article.title.downcase.tr(' ','-')
      article.published   = true
      article.created_at  = (Time.now - 604800)..Time.now
      article.body        = MongoPopulator.paragraphs(5..7)
    end

Unlike the original Populator, we are letting MongoDB set each ObjectId. This makes setting up relationships only slightly more laborious.

    article_collection = db.collection('articles')
    article_collection.populate(100) do |article|
      ...
    end

    # create array of article _ids to select from
    article_ids = db.collection('article').distinct('_id')

    comment_collection = db.collection('comments')
    comment_collection.populate(1000) do |comment|
      ...
      comment.article = article_ids
    end

That will create an average of 10 related comments for each article. 

Passing a range or array of values will randomly select one.

    person.gender = ['male', 'female']

This will create 1000 to 5000 men or women with the annual income between 10,000 and 200,000.

If you need to generate fake data, there are a few methods to do this.

    MongoPopulator.words(3) # generates 3 random words separated by spaces
    MongoPopulator.words(10..20) # generates between 10 and 20 random words
    MongoPopulator.sentences(5) # generates 5 sentences
    MongoPopulator.paragraphs(3) # generates 3 paragraphs

For fancier data generation, try the [Faker gem](http://faker.rubyforge.org).

To persist arrays in your documents, use either #items to save a certain number of items randomly selected from a set, or #array to save a specific array.

    MongoPopulator.items(1..5, %w(ape bear cat dog elephant firefox)) # populates array with provided terms
    MongoPopulator.items(10..20) # populates array with random words
    MongoPopulator.array('red', 'green', 'blue') # saves `['red', 'green', 'blue']` exactly

## TODO

* Make MongoPopulator::Factory support conditional presence of an attribute
* Support singular and multiple embedded documents

## Development

Problems or questions? Add an [issue on GitHub](https://github.com/bak/mongo_populator/issues) or fork the project and send a pull request.

## Special Thanks

MongoPopulator is highly derivative of, and heavily reuses, the work of Ryan Bates [via Populator](https://github.com/ryanb/populator/). Thanks, Ryan.

## Special Thanks for the original Populator

Special thanks to Zach Dennis for his ar-extensions gem which some of this code is based on. Also many thanks to the [contributors](https://github.com/ryanb/populator/contributors). See the [CHANGELOG](https://github.com/ryanb/populator/blob/master/CHANGELOG.rdoc) for the full list.
