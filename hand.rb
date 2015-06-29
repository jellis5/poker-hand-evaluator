class Hand
	def initialize
		@cards = []
	end
	
	def length
		@cards.length
	end
	
	def add_cards(cards_to_add)
		@cards.push(*cards_to_add)
	end
	
	def clear
		@cards.clear
	end
	
	def evaluate(com_cards)
		total_hand = @cards + com_cards
		total_hand.sort!.reverse!
		puts total_hand
		# check from greatest value hand to least
	end
	
	def to_s
		@cards.inject([]) { |acc, card| acc << card.to_s }.join("\n")
	end
end
