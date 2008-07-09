require 'brigit/commands/command'

module Brigit
  
  class HopCommand < Command
    
    def run
      ref = default_ref
      super do |parser|
        parser.on('-r TREE-ISH', '--ref', "(default: `#{ref}')") do |treeish|
          ref = treeish
        end
      end
      check_url!
      raise NotImplementedError, "TODO"
    end
    
    #######
    private
    #######
    
    def check_url!
      fail "Submodule URL required" unless submodule_url
    end
    
    def submodule_url
      @submodule_url ||= args.shift
    end

    def default_ref
      'master'
    end
    
  end
  
end