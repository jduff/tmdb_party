class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
  
end

class Float
  def self.parse(val)
    Float(val)
  end
end

class Integer
  def self.parse(val)
    Integer(val)
  end
end