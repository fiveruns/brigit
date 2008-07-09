module Brigit
  
  module Fallible
    
    def fail(message)
      abort "#{CLI.banner}\n---\n#{message}\n(See `brigit #{self.class.name} --help' for more information)"
    end
  
  end
  
end