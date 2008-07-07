module Brigit
  
  module Fallible
    
    def fail(message)
      abort "\n#{message}\n\n---\n#{CLI.usage}"
    end
  
  end
  
end