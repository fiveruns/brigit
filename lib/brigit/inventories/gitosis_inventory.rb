require 'brigit/inventories/inventory'
require 'brigit/config_parser'

module Brigit
  
  class GitosisInventory < Inventory
    
    def repositories
      @repositories ||= begin
        validate_path!
        sections.values.inject({}) do |all, section|
          %w(writable readonly).each do |field|
            tokenize(section[field]).each do |name|
              all[name] = repo_path(name)
            end
          end
          all
        end
      end
    end
    
    #######
    private
    #######
    
    def tokenize(text)
      return [] unless text
      text.scan(/(\S+)/).flatten
    end
    
    def validate_path!
      fail "No such file: #{gitosis_conf}" unless File.file?(gitosis_conf)
      fail "gitosis-admin is not a Git repository" unless File.file?(git_config)
    end

    def gitosis_conf
      File.join(path, "gitosis.conf")
    end
    
    def git_config
      File.join(path, '.git/config')
    end
    
    def base
      @base ||= begin
        config = parser.parse(File.readlines(git_config))
        config[%|remote "origin"|]['url'].sub(/:.*?$/, '')
      end
    end
    
    def repo_path(component)
      [base, component].join(':') << '.git'
    end
    
    def sections
      @sections ||= parser.parse(File.readlines(gitosis_conf))
    end
    
    def parser
      @parser ||= ConfigParser.new
    end
        
  end
  
end 