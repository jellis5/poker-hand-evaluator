require_relative 'player'

class Human < Player
	def initialize(name, chips_amount)
		super(name, chips_amount)
	end
	
	# implement option to see other person's chips later
	def take_turn(current_bet)
		choice = 1
		puts "\nYour turn.\nChips: #{@chips}\n\n"
		puts @hand
		puts "\n1: #{current_bet > 0 ? "Call #{current_bet - @current_bet_amount}" : "Check"}"
		puts "2: #{current_bet > 0 ? "Raise" : "Bet"}"
		puts "3: Check Everyone's Chips"
		puts "4: Fold"
		loop do
			begin
				print "Enter choice: "
				choice = gets.chomp.to_i
				raise TypeError if choice < 1 || choice > 4
				break
			rescue TypeError
				redo
			end
		end
		case choice
		when 1
			@chips -= current_bet - @current_bet_amount if current_bet > 0
			@current_bet_amount += current_bet
			print "#{@name} #{current_bet > 0 ? "calls" : "checks"}. Press enter to continue."
			gets
			return [1]
		when 2
			amount = 0
			loop do
				begin
					print "Enter #{current_bet > 0 ? "raise" : "bet"} amount: "
					amount = gets.chomp.to_i
					raise TypeError if amount < 1 || amount > @chips
					break
				rescue TypeError
					redo
				end
			end
			@chips -= amount
			return [2, amount]
		when 3
			return [3]
		when 4
			print "You folded. Press enter to continue."
			gets
			return [4]
		end
	end
end
