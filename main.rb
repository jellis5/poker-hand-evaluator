require_relative 'deck'
require_relative 'human'
require_relative 'computer'
require_relative 'player'
require_relative 'card'

# players array needs to cycle through players starting at a certain index
class Array
	def each_from_start(start_index)
		index, iters = start_index, 0
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
	players.each do |player|
		###################################3
	end
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
	puts "Enter your name: "
	you = Human.new(gets.chomp, chip_amount)
	loop do
		begin
			puts "Enter the number of computers (1-5): "
			num_comps = gets.chomp.to_i
			raise TypeError if num_comps < 1 || num_comps > 5
			break
		rescue TypeError
			retry
		end
	end
	players = init_players(you, num_comps, chip_amount)
	num_players = players.length
	dealer_index = rand(num_players)
	while players.map{ |player| player.chips > 0 }.length > 1
		deck = Deck.new
		deck.shuffle!
		com_cards = []
		puts "\nHand number: #{hand_num}"
		puts "Dealer: #{players[dealer_index]}\n"
		deal_hands(deck, players)
		loop do
			#take turns (bet, check, fold or call, raise, fold)
			#add com card
			first_turn = dealer_index + 1
			first_turn = first_turn % num_players if first_turn >= num_players
			print_com_cards(com_cards)
			players.each_from_start(first_turn) { |player| player.take_turn }
			break if com_cards.length == 5
			# if pre-flop (length == 0), add flop; else add turn and then river
			com_cards.push(*deck.draw_cards(com_cards.length == 0 ? 3 : 1))
		end
		#find_winner(players, com_cards)
		puts players[0].hand.evaluate(com_cards)
		hand_num += 1
	end
end

main
