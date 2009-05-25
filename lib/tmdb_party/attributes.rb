module TMDBParty
  module Attributes
    # based on http://github.com/nullstyle/ruby-satisfaction
    
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
        attr_reader :attributes
      end
    end

    module ClassMethods
      def attributes(*names)
        options = names.extract_options!

        names.each do |name|
          attribute name, options unless name.blank?
        end
      end

      def attribute(name, options)
        options.replace({:type => 'nil', :lazy=>false}.merge(options))
        raise "Name can't be empty" if name.blank?

        lazy_load = "self.#{options[:lazy]} unless self.loaded?" if options[:lazy]
        class_eval <<-EOS
  def #{name}
    #{lazy_load}
    @#{name} ||= decode_raw_attribute(@attributes['#{name}'], #{options[:type]}) if @attributes
  end
  EOS
      end

    end

    module InstanceMethods
      def attributes=(value)
        @attributes = value
      end
      
      def loaded?
        @loaded
      end

      private
      def decode_raw_attribute(value, type)
        type.respond_to?(:parse) ? type.parse(value) : value
      end
    end
  end
end