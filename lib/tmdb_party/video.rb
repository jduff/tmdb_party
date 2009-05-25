module TMDBParty
  class Video
    attr_reader :url
    
    def initialize(url)
      @url = url
    end
    
    def self.parse(data)
      if data.is_a?(Array)
        data.collect do |url|
          Video.new(url)
        end
      else
        Video.new(data)
      end
    end
  end
end