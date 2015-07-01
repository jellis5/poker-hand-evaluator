class Card
	include Comparable
	
	@@suits = [:clubs, :diamonds, :hearts, :spades]
	@@ranks = [nil, nil, :'2', :'3', :'4', :'5', :'6', :'7', :'8', :'9', :'10', :Jack, :Queen, :King, :Ace]
	
	attr_reader :rank_num, :suit, :rank
	
	def initialize(suit=0, rank=2)
		@rank_num = rank
		@suit, @rank = @@suits[suit], @@ranks[rank]
	end
	
	def <=>(other)
		@rank_num <=> other.rank_num
	end
	
	def to_s
		"#{@rank} of #{@suit}"
	end
end
