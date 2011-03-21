module TMDBParty
  class Country < Entity
    attributes :name, :code, :url
    alias_method :code_string, :code
    
    def code
      code_string.downcase.to_sym
    end
  end
end
