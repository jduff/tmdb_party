module TMDBParty
  class Video < Entity
    attr_reader :url
    
    def initialize(url)
      super
      @url = url
    end
  end
end
