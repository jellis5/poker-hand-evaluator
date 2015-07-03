require_relative 'player'

class Human < Player
	def initialize(name, chips_amount)
		super(name, chips_amount)
	end
	
	# implement option to see other person's chips later
	def take_turn(pot)
		choice = 1
		puts "\nYour turn.\nChips: #{@chips}\n\n"
		puts @hand
		puts "\n1: Check"
		puts "2: Bet"
		puts "3: Fold"
		loop do
			begin
				print "Enter choice: "
				choice = gets.chomp.to_i
				raise TypeError if choice < 1 || choice > 3
				break
			rescue TypeError
				retry
			end
		end
		case choice
		when 1
			puts "#{@name} checks. Press enter to continue."
			gets
			return [1]
		when 2
			amount = 0
			loop do
				begin
					print "Enter bet amount: "
					amount = gets.chomp.to_i
					raise TypeError if amount < 1 || amount > @chips
					break
				rescue TypeError
					retry
				end
			end
			@chips -= amount
			return [2, amount]
		end
	end
end
