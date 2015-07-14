require_relative 'card'

class Hand
	@@hands = [:'High Card', :'One Pair', :'Two Pair', :'Three of a Kind', :'Straight', :'Flush', :'Full House', :'Four of a Kind', :'Straight Flush', :'Royal Flush']

	def initialize(cards=[])
		begin
			@cards = cards.is_a?(String) ? parse_cards(cards) : cards
		rescue TypeError
			abort("Invalid argument!")
		end
		@hand_value = nil
		@hand_value_name = nil
	end
	
	attr_reader :hand_value, :hand_value_name
	
	def length
		@cards.length
	end
	
	def add_cards(cards_to_add)
		@cards.push(*cards_to_add)
	end
	
	def clear
		@cards.clear
	end
	
	def eval_hand
		@hand_value = evaluate_value
		@hand_value_name = evaluate_value_name
	end
	
	def to_s
		@cards.inject([]) { |acc, card| acc << card.to_s }.join("\n")
	end
	
	######################################################################
	# PRIVATE METHODS
	######################################################################
	
	def parse_cards(cards)
		suits_map = {c: 0, \
									d: 1, \
									h: 2, \
									s: 3}
		ret_cards = []
		cards = cards.split
		cards.each do |card|
			raise TypeError if card.length < 2 || card.length > 3
			if card.length == 2
				ret_cards << Card.new(suits_map[card[-1].to_sym], card[0].to_i)
			elsif card.length == 3
				ret_cards << Card.new(suits_map[card[-1].to_sym], card[0, 2].to_i)
			end
		end
		ret_cards
	end
	
	def royal_flush?(hand, suits)
		[9] if straight_flush?(hand, suits) == 14
	end
	
	def straight_flush?(hand, suits)
		flush_suit = nil
		suits = hand.map { |card| card.suit }
		Card::SUITS.each{ |suit| flush_suit = suit if suits.count(suit) >= 5 }
		return false if not flush_suit
		flush_cards = hand.select{ |card| card.suit == flush_suit }
		# flush exists; determine if straight exists
		consec, consec_start = 0, 0
		(0...flush_cards.length - 1).each do |i|
			consec = (flush_cards[i].rank_num == flush_cards[i+1].rank_num + 1) ? consec + 1 : 0
			if consec == 4
				consec_start = i - 3
				return [8, flush_cards[consec_start].rank_num]
			end
		end
		false
	end
	
	def four_of_a_kind?(ranks)
		ret_arr = []
		ranks.each do |rank|
			if ranks.count(rank) == 4
				ret_arr.push(7, rank)
				break
			end
		end
		ret_arr.empty? ? false : ret_arr
	end
	
	def full_house?(ranks)
		ranks.each do |rank1|
			if ranks.count(rank1) == 3
				ranks.each do |rank2|
					if ranks.count(rank2) == 2
						return [6, rank1]
					end
				end
			end
		end
		false
	end
	
	def flush?(hand, suits)
		ret_arr = []
		flush_suit = nil
		Card::SUITS.any?{ |suit| flush_suit = suit if suits.count(suit) >= 5 }
		if flush_suit
			hand.each do |card|
				if card.suit == flush_suit
					ret_arr.push(5, card.rank_num)
					break
				end
			end
		end
		ret_arr.empty? ? false : ret_arr
	end
	
	def straight?(ranks_uniq)
		consec, consec_start = 0, 0
		(0...ranks_uniq.length - 1).each do |i|
			consec = (ranks_uniq[i] == ranks_uniq[i+1] + 1) ? consec + 1 : 0
			if consec == 4
				consec_start = i - 3
				break
			end
		end
		return consec == 4 ? [4, ranks_uniq[consec_start]] : false
	end
	
	def three_of_a_kind?(ranks)
		ret_arr = []
		ranks.each do |rank|
			if ranks.count(rank) == 3
				ret_arr.push(3, rank)
				break
			end
		end
		ret_arr.empty? ? false : ret_arr
	end
	
	# kicker cards only come into play here and below
	def two_pair?(ranks)
		ret_arr = []
		ranks.each do |rank|
			if ranks.count(rank) == 2
				ret_arr << rank
			end
		end
		ret_arr.uniq!
		# if three pairs, pick biggest two
		ret_arr.pop if ret_arr.length == 3
		if ret_arr.length == 2
			ret_arr.unshift(2)
			# add kicker
			ret_arr << ranks.find { |rank| ranks.count(rank) == 1}
		end
		ret_arr.length == 4 ? ret_arr : false
	end
	
	def one_pair?(ranks)
		ret_arr, kickers = [], []
		ranks.each do |rank|
			if ranks.count(rank) == 2
				ret_arr.push(1, rank)
				break
			end
		end
		ranks.each do |rank|
			if ranks.count(rank) == 1
				ret_arr << rank
				break
			end
		end
		ret_arr[0] == 1 ? ret_arr : false
	end
	
	def evaluate_value
		hand = @cards.sort.reverse
		ranks = hand.map { |card| card.rank_num }
		ranks_uniq = ranks.uniq
		suits = hand.map { |card| card.suit }
		# check from greatest value hand to least
		if hand_value = royal_flush?(hand, suits)
			return hand_value
		else
			if hand_value = straight_flush?(hand, suits)
				return hand_value
			else
				if hand_value = four_of_a_kind?(ranks)
					return hand_value
				else
					if hand_value = full_house?(ranks)
						return hand_value
					else
						if hand_value = flush?(hand, suits)
							return hand_value
						else
							if hand_value = straight?(ranks_uniq)
								return hand_value
							else
								if hand_value = three_of_a_kind?(ranks)
									return hand_value
								else
									if hand_value = two_pair?(ranks)
										return hand_value
									else
										if hand_value = one_pair?(ranks)
											return hand_value
										end
										# 0 for high card
										return [0, ranks[0]]
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	def evaluate_value_name
		ret_string = @@hands[@hand_value[0]].to_s
		case @hand_value[0]
		when 0, 1, 3, 7
			ret_string += " (#{Card::RANKS[@hand_value[1]]})"
		when 2
			ret_string += " (#{Card::RANKS[hand_value[1]]}, #{Card::RANKS[hand_value[2]]})"
		when 4, 5, 8
			ret_string += " (#{Card::RANKS[hand_value[1]]} high)"
		when 6
			ret_string += " (#{Card::RANKS[hand_value[1]]}s over #{Card::RANKS[hand_value[2]]}s)"
		end
		ret_string
	end
			
	private :royal_flush?, :straight_flush?, :four_of_a_kind?, :full_house?, :flush?, :straight?, :three_of_a_kind?, :two_pair?, :one_pair?, :evaluate_value, :evaluate_value_name
	
end
