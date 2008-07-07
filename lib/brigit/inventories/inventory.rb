require 'brigit/listable'
require 'brigit/fallible'

module Brigit
  
  class Inventory
    include Listable
    include Fallible
    
    attr_reader :path
    def initialize(path)
      @path = path
    end
    
    def repositories
      raise NotImplementedError, 'Abstract'
    end
    
  end
  
end
