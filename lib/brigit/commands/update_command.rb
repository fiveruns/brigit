require 'brigit/commands/command'
require 'find'

module Brigit
  
  class UpdateCommand < Command
        
    def run
      pull = false
      super do
        parser.on('-p', '--pull', "Pull repo (remote branch must have same name)") do
          pull = true
        end
      end
      if pull
        sh "git pull origin '#{Brigit.repo.current_branch}'"
      end
      Brigit.at_dot_gitmodules do |path|
        say "---\nSubmodule: #{path}"
        sh "git submodule init"
        sh "git submodule update"
      end
    end
    
  end
  
end