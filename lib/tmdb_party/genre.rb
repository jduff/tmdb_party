module TMDBParty
  class Genre < Entity
    attributes :id, :type => Integer
    attributes :name, :url
  end
end
