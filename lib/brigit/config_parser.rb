module Brigit
  
  # Reworked from Sam Ruby's Ruby "PythonConfigParser," http://intertwingly.net/code/mars/planet/config.rb
  # which in turn is a port of Python's ConfigParser, http://docs.python.org/lib/module-ConfigParser.html
  class ConfigParser
    
    class Section
      
      attr_reader :name
      def initialize(name)
        @name = name
      end
      
      def options
        @options ||= {}
      end
      
      def method_missing(*args, &block)
        options.__send__(*args, &block)
      end
      
    end

    SECTION = /
      \[                    # [
      ([^\]]+)              # very permissive!
      \]                    # ]
    /x

    OPTION = /
      ([^:=\s][^:=]*)       # very permissive!
      \s*[:=]\s*            # any number of space chars,
                            # followed by separator
                            # (either : or =), followed
                            # by any # space chars
      (.*)$                 # everything up to eol
    /x


    # FIXME: This is *way* ugly     
    def parse(lines)
      sections = Hash.new { |_, name| Section.new(name) }
      section = nil
      option = nil
      lines.each_with_index do |line, number|
        next if skip? line
        if line =~ OPTION
          # option line
          option, value = $1, $2
          option = option.downcase.strip
          value.sub!(/\s;.*/, '')
          value = '' if value == '""'
          section[option] = clean value
        elsif line =~ /^\s/ && section && option
          # continuation line
          value = line.strip
          section[option] = section[option] ? (section[option] << "\n#{clean value}") : clean(value)
        elsif line =~ SECTION
          section = sections[$1]
          sections[$1] = section
          option = nil
        elsif !section
          raise SyntaxError, 'Missing section header'
        else
          raise SyntaxError, "Invalid syntax on line #{number}"
        end
      end
      sections
    end
    
    #######
    private
    #######
    
    def clean(value)
      value.sub(/\s*#.*/, '')
    end
    
    def skip?(line)
      line.strip.empty? || line =~ /^\s*[#;]/ || line =~ /^rem(\s|$)/i
    end
    
  end
  
end
  