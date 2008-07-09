require 'brigit/commands/command'

module Brigit
  
  class HopCommand < Command
    
    def run
      ref = default_ref
      super do |parser|
        parser.on('-r TREE-ISH', '--ref', "(default: `#{ref}')") do |treeish|
          ref = treeish
        end
        add_pretend_to parser
      end
      check_url!
      changed = []
      errors = []
      submodules.each do |path, parent|
        Dir.chdir path do
          say "cd #{path}"
          if clean?
            sh 'git pull origin master'
            sh "git checkout '#{ref}'"
            changed << parent
          else
            say "Working directory isn't clean, skipping"
            errors << path
          end
        end
      end
      if changed.any?
        say "---\nPlease check and commit the following parent repositories:\n#{format_list changed}"
      end
      if errors.any?
        say "---\nCould not update the following locations:\n#{format_list errors}"
      end
    end
    
    #######
    private
    #######
    
    def format_list(list)
      list.map { |item| "  #{item}" }.join("\n")
    end
    
    def clean?
      `git status` =~ /working directory clean/
    end
    
    def valid?(path)
      return false unless Brigit.submodule?(path)
      config_file = File.join(path, '.git/config')
      url = config_parser.parse(File.readlines(config_file))['remote "origin"']['url'] rescue nil
      return false unless url
      normalize(submodule_url) == normalize(url)
    end
    
    def config_parser
      @config_parser ||= ConfigParser.new
    end
    
    def check_url!
      fail "Submodule URL required" unless submodule_url
    end
    
    def normalize(url)
      url =~ /\.git$/ ? url : "#{url}.git"
    end
    
    def submodule_url
      @submodule_url ||= args.shift
    end
    
    def submodules
      @submodules ||= begin
        list = []
        Brigit.at_repos(true) do |path|
          list << [path, Brigit.parent_of(path)] if valid?(path)
        end
        list
      end
    end

    def default_ref
      'master'
    end
    
  end
  
end