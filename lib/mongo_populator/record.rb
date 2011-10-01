module MongoPopulator
  # This is what is passed to the block when calling populate.
  class Record
    attr_accessor :attributes

    # Creates a new instance of Record. 
    def initialize(collection)
      @attributes = {}
    end

    def attributes=(values_hash)
      values_hash.each_pair do |key, value|
        value = value.call if value.is_a?(Proc)
        self.send((key.to_s + "=").to_sym, value)
      end
    end

    private

    def method_missing(sym, *args, &block)
      name = sym.to_s
      if name.include?('=')
        rtn = MongoPopulator.interpret_value(args.first)
        unless rtn.nil?
          @attributes[name.sub('=', '').to_sym] = rtn
        end
      else
        @attributes[sym]
      end
    end
  end
end

