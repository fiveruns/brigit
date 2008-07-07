require 'brigit/commands/command'
require 'find'

module Brigit
  
  class MapCommand < Command
    
    self.help = "Graphs of submodules in this repository"
    
    def execute!
      super
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
      if options.open
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
      result = parser.parse(File.readlines(filename))
      result['remote "origin"']['url']
    end
    
    def submodules_at(path)
      filename = File.join(path, '.gitmodules')
      result = parser.parse(File.readlines(filename))
      result.values
    end

    def parser
      @parser ||= ConfigParser.new
    end
      
  end
  
end