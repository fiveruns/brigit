require File.dirname(__FILE__) << "/command"
require 'yaml'

module Brigit
  
  class InfoCommand < Command
    
    def execute!
      puts "Profile: #{options.profile.name || :default}"
      puts "Repositories (from #{options.profile.gitosis_admin.location}):"
      show options.profile.gitosis_admin.repositories
      puts "Applications:"
      show options.profile.applications
    end    
    
    #######
    private
    #######

    def show(list)
      puts list.sort.to_yaml[5..-1]
    end
    
  end
  
end