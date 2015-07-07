require_relative 'player'

class Computer < Player
	@@name_num = 1
	
	def initialize(chips_amount)
		super("Computer_#{@@name_num}", chips_amount)
		@@name_num += 1
	end
	
	def take_turn(current_bet)
		puts "#{@name}'s turn..."
		if current_bet > 0
			@chips -= current_bet - @current_bet_amount
			@current_bet_amount += current_bet
			puts "#{@name} calls. Chips: #{@chips}"
		else
			puts "#{@name} checks."
		end
		return [1]
		sleep(0)
	end
end
