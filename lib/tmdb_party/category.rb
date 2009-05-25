module TMDBParty
  class Category
    include Attributes
    attributes :name, :url
    
    def initialize(values)
      self.attributes = values
    end
    
    def self.parse(data)
      data = data["category"]
      if data.is_a?(Array)
        data.collect do |category|
          Category.new(category)
        end
      else
        Category.new(data)
      end
    end
  end
end