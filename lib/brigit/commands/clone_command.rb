require File.dirname(__FILE__) << "/command"

module Brigit
  
  class CloneCommand < Command
    self.help = 'Clone all repositories (matching optional patterns)'
    
    def execute!
      STDERR.puts "Missing Repositories:"
      if missing_repos.any?
        STDERR.puts missing_repos.map { |repo| "  #{repo}" }
        STDERR.print "Clone these missing repos? [Y/n]: "
        clone_missing_repos! unless STDIN.gets =~ /n/i
      else
        STDERR.puts "  NONE"
      end
    end
    
    #######
    private
    #######
    
    def clone_missing_repos!
      missing_repos.each do |name|
        system "git clone '#{repos[name]}' '#{name}'"
      end
    end
    
    def missing_repos
      @missing_repos ||= repos.keys.select { |path| !File.exists?(path) }
    end

    def repos
      @repos ||= begin
        list = options.profile.repositories.select do |k, v|
          if args.empty?
            true
          else
            args.any? { |arg| k.include?(arg) }
          end
        end
        Hash[*list.flatten]
      end
    end
    
  end
  
end