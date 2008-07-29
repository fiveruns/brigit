require 'brigit/commands/command'
require 'find'

module Brigit
  
  class StatusCommand < Command
        
    def run
      super
      say "<%= color '#{Dir.pwd}', :yellow, :bold %>"
      sh "git status"
      Brigit.at_dot_gitmodules do |path|
        submodules_at(path).each do |sub|
          say %<\n<%= color 'Submodule:', :yellow %> <%= color '#{sub['path']}', :yellow, :bold %> <%= color "(#{sub['url']})", :white %>>
          Dir.chdir sub['path'] do
            sh "git status"
          end
        end
      end
    end
    
  end
  
end