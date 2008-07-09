require 'brigit/commands/command'
require 'find'

module Brigit
  
  class UpdateCommand < Command
        
    def run
      super
      Brigit.at_dot_gitmodules do |path|
        sh "git submodule init"
        sh "git submodule update"
      end
    end
    
  end
  
end