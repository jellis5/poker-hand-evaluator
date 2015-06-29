require_relative 'player'

class Human < Player
	def initialize(name, chips_amount)
		super(name, chips_amount)
	end
	
	def take_turn
		puts "Your turn.\n\n"
		puts @hand
		puts "\n1: Check"
		puts "2: Bet"
		puts "3: Fold"
		loop do
			begin
				puts "Enter choice: "
				choice = gets.chomp.to_i
				raise TypeError if choice < 1 || choice > 3
				break
			rescue TypeError
				retry
			end
		end
	end
end
