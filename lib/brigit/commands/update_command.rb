require 'brigit/commands/command'
require 'find'

module Brigit
  
  class UpdateCommand < Command
        
    def run
      pull = false
      super do
        parser.on('-p', '--pull', "Pull master repo (if on branch `master')") do
          pull = true
        end
      end
      if pull
        if Brigit.repo.branch.name == 'master'
          sh "git pull origin master"
        else
          say "Not on `master' branch; skipping update of main repo..."
        end
      end
      Brigit.at_dot_gitmodules do |path|
        say "---\nSubmodule: #{path}"
        sh "git submodule init"
        sh "git submodule update"
      end
    end
    
  end
  
end