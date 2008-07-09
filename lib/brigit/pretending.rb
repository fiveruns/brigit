module Brigit
  
  module Pretending
    
    def pretend!
      @pretending = true
    end
    
    #######
    private
    #######
    
    def add_pretend_to(parser)
      parser.on('-p', '--pretend', "Just pretend to #{self.class.name}") do
        pretend!
      end
    end
    
    def pretending?
      @pretending
    end
    
  end
  
end