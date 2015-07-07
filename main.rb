require_relative 'deck'
require_relative 'human'
require_relative 'computer'
require_relative 'player'
require_relative 'card' # take this out later

# players array needs to cycle through players starting at a certain index
class Array
	def each_from_start(start_index)
		index, iters = start_index >= self.length ? start_index % self.length : start_index, 0
		if block_given?
			while iters < self.length
				iters += 1
				yield self[index]
				index += 1
				index = index % self.length if index >= self.length
			end
		end
	end
end

def find_winner(players, com_cards)
	winner = players[0]
	players.each{ |player| player.hand.eval_hand(com_cards) }
	print "Let's see who won. Press enter to continue."
	gets
	players.drop(1).each do |player|
		player.hand.hand_value.each_with_index do |value, ind|
			if value < winner.hand.hand_value[ind]
				break
			elsif value > winner.hand.hand_value[ind]
				winner = player
				break
			end
		end
	end
	players.each do |player|
		print_com_cards(com_cards)
		puts "\n#{player.name} has..."
		puts "#{player.hand.hand_value_name}\n"
		puts "\n#{player.hand}"
		print "\nPress enter to continue."
		gets
	end
	puts "#{winner} wins!"
	winner
end

def print_com_cards(com_cards)
	puts "\nCommunity cards:"
	com_cards.each { |card| puts card }
	puts
end

def init_players(you, num_comps, chip_amount)
	players = []
	players << you
	num_comps.times { players << Computer.new(chip_amount) }
	players
end

def deal_hands(deck, players)
	players.each do |player|
		player.hand.clear if player.hand.length != 0
		player.hand.add_cards(deck.draw_cards(2))
	end
end

def main
	puts "Welcome to Texas Hold \'em!"
	hand_num = 1
	num_comps = 1
	chip_amount = 500
	name = ''
	until not name.empty? do
		print "Enter your name: "
		name = gets.chomp
	end
	you = Human.new(name, chip_amount)
	loop do
		begin
			print "Enter the number of computers (1-5): "
			num_comps = gets.chomp.to_i
			raise TypeError if num_comps < 1 || num_comps > 5
			break
		rescue TypeError
			redo
		end
	end
	players = init_players(you, num_comps, chip_amount)
	num_players = players.length
	dealer_index = rand(num_players)
	while players.map{ |player| player.chips > 0 }.length > 1
		deck = Deck.new
		deck.shuffle!
		active_players = players.dup
		com_cards = []
		pot = 0
		puts "\nHand number: #{hand_num}"
		puts "Dealer: #{players[dealer_index]}\n"
		deal_hands(deck, players)
		loop do
			first_turn = dealer_index + 1 >= active_players.length ? 0 : dealer_index + 1
			print_com_cards(com_cards)
			puts "Pot: #{pot}\n\n"
			current_bet = 0
			last_turn_index = first_turn - 1 < 0 ? active_players.length - 1 : first_turn - 1
			loop do
				puts first_turn, last_turn_index
				turn_arr = active_players[first_turn].take_turn(current_bet)
				if turn_arr[0] == 2
					current_bet += turn_arr[1]
					last_turn_index = first_turn - 1 < 0 ? active_players.length - 1 : first_turn - 1
				elsif turn_arr[0] == 3
					active_players.delete_at(first_turn)
				end
				break if (first_turn == last_turn_index) && (active_players[first_turn].current_bet_amount == current_bet)
				first_turn = first_turn + 1 >= active_players.length ? 0 : first_turn + 1
			end
			active_players.each { |player| player.current_bet_amount = 0 }
			break if com_cards.length == 5
			# if pre-flop (length == 0), add flop; else add turn and then river
			com_cards.push(*deck.draw_cards(com_cards.length == 0 ? 3 : 1))
		end
		find_winner(players, com_cards)
		hand_num += 1
		dealer_index += 1
		dealer_index = dealer_index % players.length if dealer_index == players.length
	end
end

main
