require 'optparse'
require_relative 'card'
require_relative 'deck'
require_relative 'hand'

# parse options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

hand = ARGV.length == 1 ? Hand.new(ARGV[0]) : Hand.new
hand.eval_hand
puts hand.hand_value_name
