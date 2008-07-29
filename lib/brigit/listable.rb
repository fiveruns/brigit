module Brigit
  
  module Listable
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      def [](name)
        matching = list.select { |klass| klass.name =~ /^#{Regexp.quote name}/io }
        return false unless matching.any?
        if matching.size > 1
          HighLine.say %|<%= color "Too many matches for `#{name}'", :red %>|
          return false
        end
        matching.first
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