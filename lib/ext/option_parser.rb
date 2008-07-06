require 'optparse'

# Fix OptionParser#separator's handling of strings with newlines
# From http://rubyforge.org/tracker/?func=detail&atid=1700&aid=9177&group_id=426
class OptionParser
  
  def separator(string)
    string.split(/\n/).each do |line|
      top.append(line.chomp, nil, nil)
    end
  end
  
end