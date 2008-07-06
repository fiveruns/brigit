module Brigit
  
  class Profile

    attr_reader :name 
    def initialize(name = nil, &block)
      @name = name ? name.to_s : nil
      yield self if block_given?
    end
    
    def gitosis_admin
      @gitosis_admin ||= GitosisAdmin.new(self)
    end
    
    def repositories
      if defined?(@gitosis_admin)
        @gitosis_admin.repositories
      else
        @repositories ||= {}
      end
    end
    
    def path_for(path)
      File.expand_path(File.join("~/.brigit/profiles/#{name || :default}", path))
    end
    
    def applications
      gitosis_admin.repositories.select do |repo|
        !repo.include?('/') || repo !~ /\b(lib|doc)\b/
      end
    end
    
  end
  
end