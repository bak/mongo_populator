module MongoPopulator
  # Builds multiple Populator::Record instances and saves them to the database
  class Factory

    @factories = {}
    @depth = 0

    # Fetches the factory dedicated to a given collection. You should always use this
    # method instead of instatiating a factory directly so that a single factory is
    # shared on multiple calls.
    def self.for_collection(collection)
      @factories[collection] ||= new(collection)
    end    

    # Find all remaining factories and call save_records on them.
    def self.save_remaining_records
      @factories.values.each do |factory|
        factory.save_records
      end
      @factories = {}
    end    

    # Keep track of nested factory calls so we can save the remaining records once we
    # are done with the base factory. This makes Populator more efficient when nesting
    # factories.
    def self.remember_depth
      @depth += 1
      yield
      @depth -= 1
      save_remaining_records if @depth.zero?
    end    

    # Use for_collection instead of instatiating a record directly.
    def initialize(collection)
      @collection = collection
      @records = []
    end    

    # Entry method for building records. Delegates to build_records after remember_depth.
    def populate(amount, &block)
      self.class.remember_depth do
        build_records(MongoPopulator.interpret_value(amount), &block)
      end
    end

    # Builds multiple MongoPopulator::Record instances and calls save_records them when
    # :per_query limit option is reached.
    def build_records(amount, &block)
      amount.times do
        # index = last_id_in_database + @records.size + 1
        record = Record.new(@collection)
        block.call(record) if block
        @records << record.attributes.delete_if {|k,v| v.is_a?(MongoSkip) }
        save_records 
      end
    end

    # Saves the records to the database 
    def save_records
      @records.each do |record|
        @collection.insert(record)
      end
      # @last_id_in_database = @records.last[:_id]
      @records.clear
    end

    private

    # def last_id_in_database
    #   @last_id_in_database ||= @collection.distinct('_id').last
    # end
  end
end
