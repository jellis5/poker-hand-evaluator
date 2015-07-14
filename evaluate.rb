require 'optparse'
require_relative 'card'
require_relative 'deck'
require_relative 'hand'

# parse options
options = {}
begin
	OptionParser.new do |opts|
		opts.banner = "Usage: #{$0} [options]"

		opts.on("-s", "--as-string STRING", "Pass in hand as string to be evaluated") do |s|
			options[:s] = s
		end
  
		opts.on("-r", "--random NUM", "Run NUM random hands") do |r|
			options[:r] = r
		end
  
	end.parse!
rescue OptionParser::InvalidOption
	abort("Invalid option supplied!")
rescue OptionParser::MissingArgument
	abort("Argument missing!")
end

abort("No arguments given!") if options.empty?
abort("Improper arguments!") if options.length > 1
if options.has_key?(:s)
	begin
		puts Hand.eval_string(options[:s])
	rescue TypeError
		abort("String argument not valid!")
	end
else
	begin
		results = Hand.eval_num(options[:r])
	rescue TypeError
		abort("Num argument not valid!")
	end
	results.each_with_index { |num, i| puts "#{Hand::HANDS[i]}: #{num}" }
end
