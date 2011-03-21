module TMDBParty
  class Category < Entity
    attributes :name, :url
    
    #FIXME This should work with the default Entity.parse
    def self.parse(data)
      return unless data
      data = data["category"]
      if data.is_a?(Array)
        data.collect do |category|
          Category.new(category)
        end
      else
        [Category.new(data)]
      end
    end
  end
end
