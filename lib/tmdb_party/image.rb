module TMDBParty
  class Image
    attr_reader :url
    
    def initialize(url)
      @url = url
    end
    
    def self.parse(data)
      if data.is_a?(Array)
        data.collect do |url|
          Image.new(url)
        end
      else
        Image.new(data)
      end
    end
  end
end