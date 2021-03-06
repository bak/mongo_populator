module MongoPopulator
  # This module adds several methods for generating random data which can be
  # called directly on Populator.
  
  module Random
    WORDS = %w(alias consequatur aut perferendis sit voluptatem accusantium doloremque aperiam eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo aspernatur aut odit aut fugit sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt neque dolorem ipsum quia dolor sit amet consectetur adipisci velit sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem ut enim ad minima veniam quis nostrum exercitationem ullam corporis nemo enim ipsam voluptatem quia voluptas sit suscipit laboriosam nisi ut aliquid ex ea commodi consequatur quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae et iusto odio dignissimos ducimus qui blanditiis praesentium laudantium totam rem voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident sed ut perspiciatis unde omnis iste natus error similique sunt in culpa qui officia deserunt mollitia animi id est laborum et dolorum fuga et harum quidem rerum facilis est et expedita distinctio nam libero tempore soluta nobis est eligendi optio cumque nihil impedit quo porro quisquam est qui minus id quod maxime placeat facere possimus omnis voluptas assumenda est omnis dolor repellendus temporibus autem quibusdam et aut consequatur vel illum qui dolorem eum fugiat quo voluptas nulla pariatur at vero eos et accusamus officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae itaque earum rerum hic tenetur a sapiente delectus ut aut reiciendis voluptatibus maiores doloribus asperiores repellat)

    # Pick a random value out of a given range.
    def value_in_range(range)
      case range.first
      when Integer then number_in_range(range)
      when Time then time_in_range(range)
      when Date then date_in_range(range)
      else range.to_a[rand(range.to_a.size)]
      end
    end

    # Generate a given number of words. If a range is passed, it will generate
    # a random number of words within that range.
    def words(total)
      (1..interpret_value(total)).map { WORDS[rand(WORDS.size)] }.join(' ')
    end

    # Generate a given number of sentences. If a range is passed, it will generate
    # a random number of sentences within that range.
    def sentences(total)
      (1..interpret_value(total)).map do
        words(5..20).capitalize
      end.join('. ')
    end

    # Generate a given number of paragraphs. If a range is passed, it will generate
    # a random number of paragraphs within that range.
    def paragraphs(total)
      (1..interpret_value(total)).map do
        sentences(3..8).capitalize
      end.join("\n\n")
    end
        
    # Generate a given number of items, or for a range, generate a random number of
    # items within that range, using values in array, or random words. Returns MongoArray.
    # Resulting items should be a unique set, therefore if minimum number requested exceeds 
    # number of items available, provide fewer items.
    def items(total, arr=nil)
      if arr && arr.map{|e| e.class}.include?(MongoSkip)
        raise StandardError, "#skip method is not permitted in the #items array argument"
      end

      # limit returned size to arr size if arr is not large enough
      min = total.is_a?(Range) ? total.first : total
      if arr
        total = (min <= arr.size) ? total : arr.size
      end

      out = MongoArray.new
      target = interpret_value(total)
      until out.size == target do
        out << (arr ? arr[rand(arr.size)] : words(1))
        out.uniq!
      end
      out
    end

    # Simply pass the values back out as a MongoArray
    def array(*values)
      if values.map {|e| e.class}.include?(MongoSkip)
        raise StandardError, "#skip method is not a permitted argument to #array"
      end
      MongoArray.new(values)
    end

    # Simply pass the values back out as a MongoDictionary
    def dictionary(dict)
      if dict.values.map {|e| e.class}.include?(MongoSkip)
        raise StandardError, "#skip method is not a permitted value in #dictionary"
      end
      md = MongoDictionary.new()
      dict.each {|k,v| md[k]=v}
      md
    end

    # Because the mongo gem sets NULL for a value of `nil` instead of skipping the field 
    # altogether, we need a way to suppress a field from a doc so we don't surprise anyone.
    # See #build_records in factory.rb for how this is done in parent documents, and 
    # #embed in this file for how it is done in embedded documents.
    def skip()
      MongoSkip.new
    end

    # Create n embedded documents from a template hash
    def embed(total, template)
      out = MongoArray.new
      (1..interpret_value(total)).map do
        md = MongoDictionary.new
        template.each_pair { |k,v|
          iv = interpret_value(v)
          md[k] = iv unless iv.is_a?(MongoSkip)
        }
        out << md
      end
      out
    end
    
    # If an array or range is passed, a random value will be selected to match.
    # All other values are simply returned.
    def interpret_value(value)
      case value
      when MongoArray then value
      when Array then value[rand(value.size)]
      when Range then value_in_range(value)
      else value
      end
    end

    private

    def time_in_range(range)
      Time.at number_in_range(Range.new(range.first.to_i, range.last.to_i, range.exclude_end?))
    end

    def date_in_range(range)
      Date.jd number_in_range(Range.new(range.first.jd, range.last.jd, range.exclude_end?))
    end

    def number_in_range(range)
      if range.exclude_end?
        rand(range.last - range.first) + range.first
      else
        rand((range.last+1) - range.first) + range.first
      end
    end
  end

  extend Random # load it into the populator module directly so we can call the methods
end
