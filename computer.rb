require_relative 'player'

class Computer < Player
	@@name_num = 1
	
	def initialize(chips_amount)
		super("Computer_#{@@name_num}", chips_amount)
		@@name_num += 1
	end
	
	def take_turn
		puts "#{@name}'s turn..."
		puts "#{@name} checks."
		return [1]
		sleep(0)
	end
end
