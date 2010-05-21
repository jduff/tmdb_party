module TMDBParty
  class CastMember
    include Attributes
    attributes :name, :url, :job
    attributes :id, :type => Integer
    
    def initialize(values)
      self.attributes = values
    end
    
    def character_name
      read_attribute('character')
    end
    
    def image_url
      read_attribute('profile')
    end
    
    def self.parse(data)
      return unless data
      if data.is_a?(Array)
        data.collect do |person|
          CastMember.new(person)
        end
      else
        [CastMember.new(data)]
      end
    end
  end
end