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
		
		opts.on("-t", "--threads NUM", "Multithreading for random hands. Use only with non-GIL implementations (like JRuby and Rubinius)") do |t|
			options[:t] = t
		end
  
	end.parse!
rescue OptionParser::InvalidOption
	abort("Invalid option supplied!")
rescue OptionParser::MissingArgument
	abort("Argument missing!")
end

if options.empty?
	abort("No arguments given!")
elsif (options.length == 2 && options.has_key?(:s)) || (options.length > 2)
	abort("Improper arguments")
end

if options.has_key?(:s)
	begin
		puts Hand.eval_string(options[:s])
	rescue TypeError
		abort("String argument not valid!")
	end
else
	begin
		results = Hand.eval_num(options[:r], options[:t])
	rescue TypeError
		abort("Num argument not valid!")
	end
	results.each_with_index { |num, i| puts "#{Hand::HANDS[i]}: #{num}" }
end
