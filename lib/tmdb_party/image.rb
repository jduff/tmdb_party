module TMDBParty
  class Image
    attr_reader :url, :type, :size
    
    def initialize(options={})
      @url = options["url"]
      @type = options["type"]
      @size = options["size"]
    end
    
    def self.parse(data)
      puts data.inspect
      puts
      puts
      if data.is_a?(Array)
        data.collect do |image|
          Image.new(image["image"])
        end
      else
        Image.new(image["image"])
      end
    end
  end
end