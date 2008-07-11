module Brigit
  
  module Listable
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      def [](name)
        list.detect { |klass| klass.name == name }
      end

      def inherited(klass)
        list << klass
      end

      def list
        @list ||= []
      end
      
      def listing
        list.map do |l|
          block_given? ? yield(l.name) : l.name
        end.join(', ')
      end

      def name
        to_s.sub(/^(?:.+::)?(.+?)[A-Z][a-z]+$/, '\1').downcase
      end
      
    end
    
  end
  
end