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
	
######################################################################
# WORK ON THIS
	
	def royal_flush?(total_hand)
		counter = 14
		ranks_uniq = total_hand.map { |card| card.rank_num }.uniq
		# test if A-10
		ranks_uniq.each do |rank|
			break if counter == 9
			return false if rank != counter
			counter -= 1
		end
		# test if suits are same
		suits = total_hand.map { |card| card.suit if card.rank_num.between?(10, 14) }.compact
		[:clubs, :hearts, :diamonds, :spades].map{ |suit| suits.count(suit) }.any?{ |suitNum| suitNum >= 5 }
	end
	
	def straight_flush?(total_hand)
		consec, consec_start = 0, 0
		ranks_uniq = total_hand.map { |card| card.rank_num }.uniq
		(0...ranks_uniq.length - 1).each do |i|
			consec = (ranks_uniq[i] == ranks_uniq[i+1] + 1) ? consec + 1 : 0
			if consec == 4
				consec_start = i - 3
				break
			end
		end
		if consec == 4
			puts 'test'
			suits = total_hand.map { |card| card.suit if card.rank_num.between?(ranks_uniq[consec_start+4], ranks_uniq[consec_start]) }.compact
			flush_suit = nil
			[:clubs, :hearts, :diamonds, :spades].map{ |suit| suits.count(suit) }.any?{ |suitNum| flush_suit = suit if suitNum >= 5 }
		end
		false
	end
	
######################################################################
	
	def four_of_a_kind?(total_hand)
		ranks = total_hand.map{ |card| card.rank_num }
		ranks.each{ |rank| return rank if ranks.count(rank) == 4 }
		false
	end
	
	def full_house?(total_hand)
		ranks = total_hand.map{ |card| card.rank_num }
		ranks.each do |rank1|
			if ranks.count(rank1) == 3
				ranks.each{ |rank2| return rank1 if ranks.count(rank2) == 2 }
				return false
			end
		end
	end
	
	def flush?(total_hand)
		suits = total_hand.map { |card| card.suit }
		flush_suit = nil
		[:clubs, :diamonds, :hearts, :spades].any?{ |suit| flush_suit = suit if suits.count(suit) >= 5 }
		if flush_suit
			total_hand.each{ |card| return card.rank_num if card.suit == flush_suit }
		end
		false
	end
	
	def straight?(total_hand)
		consec, consec_start = 0, 0
		ranks_uniq = total_hand.map { |card| card.rank_num }.uniq
		(0...ranks_uniq.length - 1).each do |i|
			consec = (ranks_uniq[i] == ranks_uniq[i+1] + 1) ? consec + 1 : 0
			if consec == 4
				consec_start = i - 3
				break
			end
		end
		return consec == 4 ? ranks_uniq[consec_start] : false
	end
	
	def three_of_a_kind?(total_hand)
		ranks = total_hand.map{ |card| card.rank_num }
		ranks.each{ |rank| return rank if ranks.count(rank) == 3 }
		false
	end
	
	def two_pair?(total_hand)
		ranks = total_hand.map{ |card| card.rank_num }
		ranks.each do |rank1|
			if ranks.count(rank1) == 2
				ranks.each{ |rank2| return [rank1, rank2] if rank2 != rank1 && ranks.count(rank2) == 2 }
			end
		end
		false
	end
	
	private :royal_flush?, :straight_flush?, :four_of_a_kind?, :full_house?, :flush?, :straight?, :three_of_a_kind?, :two_pair?
	
	def evaluate(com_cards)
		total_hand = @cards + com_cards
		total_hand.sort!.reverse!
		puts total_hand
		# check from greatest value hand to least
		ranks = total_hand.map { |card| card.rank_num }
		ranks_uniq = ranks.uniq
		suits = total_hand.map { |card| card.suit }
		#puts two_pair?(total_hand)
		#puts full_house?(total_hand)
		#puts four_of_a_kind?(total_hand)
		#puts royal_flush?(total_hand)
		#puts straight_flush?(total_hand)
	end
	
	def to_s
		@cards.inject([]) { |acc, card| acc << card.to_s }.join("\n")
	end
end
