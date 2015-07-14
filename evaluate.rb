require 'optparse'
require_relative 'card'
require_relative 'deck'
require_relative 'hand'

# parse options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-s", "--as-string STRING", "Pass in hand as string to be evaluated") do |s|
    options[:s] = s
  end
  
  opts.on("-r", "--random NUM", "Run NUM random hands") do |r|
	options[:r] = r
  end
  
end.parse!

abort("No arguments given!") if options.empty?
abort("Improper arguments!") if options.length > 1
begin
	puts Hand.eval_string(options[:s])
rescue TypeError
	abort("String argument not valid!")
end