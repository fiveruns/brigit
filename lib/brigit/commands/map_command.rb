require 'brigit/commands/command'
require 'find'

module Brigit
  
  class MapCommand < Command
    
    def run
      open = false
      super do |parser|
        parser.on('-o', '--open', "Open as PNG in Preview.app (OSX only, requires `dot')") do
          open = true
        end
      end
      text =  %|digraph G {\n|
      # TODO: Allow customization
      text << %|ranksep=.75; size = "12,12";\n|
      base = Dir.pwd
      Brigit.at_dot_gitmodules do |path|
        origin = origin_at(path)
        text << %|  "#{origin}" [shape="box",style=filled,fillcolor=lightgrey];\n|
        submodules_at(path).each do |submodule|
          text << %| "#{origin}" -> "#{submodule['url']}" [fontsize=16,label="#{submodule['path']}"];\n|
        end
      end
      text << %|}\n|
      if open
        IO.popen("dot -Tpng | open -f -a /Applications/Preview.app", 'w') do |file|
          file.write text
        end
      else
        puts text
      end
    end
    
    #######
    private
    #######
    
    def origin_at(path)
      filename = File.join(path, '.git/config')
      result = config_parser.parse(File.readlines(filename))
      result['remote "origin"']['url']
    end
    
    def submodules_at(path)
      filename = File.join(path, '.gitmodules')
      result = config_parser.parse(File.readlines(filename))
      result.values
    end

    def config_parser
      @config_parser ||= ConfigParser.new
    end
      
  end
  
end