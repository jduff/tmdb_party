module TMDBParty
  class Image
    def initialize(attributes)
      @attributes = attributes
    end
    
    def id
      @attributes['id']
    end
    
    def type
      @attributes['type'].downcase.to_sym
    end
    
    def sizes
      @attributes['sizes'].map { |size| size.downcase.to_sym }.to_set
    end
    
    def url
      original_url
    end
    
    def method_missing(*args, &block)
      if args.first.to_s =~ /\A(.*)_url\Z/
        @attributes["#{$1}_url"]
      else
        super
      end
    end
    
    class << self
      def parse(data)
        data.map { |row| row['image'] }.group_by { |row| row['id'] }.map do |id, images|
          Image.new(reduce_images(images))
        end
      end
      
      protected
        def reduce_images(images)
          images.inject({'sizes' => []}) do |image, row|
            image["#{row['size']}_url"] = row.delete('url')
            image['sizes'] << row.delete('size')
            image.merge(row)
          end
        end
    end
    
  end
end