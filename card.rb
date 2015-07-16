class Card
    include Comparable
    
    SUITS = [:clubs, :diamonds, :hearts, :spades]
    RANKS = [nil, nil, :'2', :'3', :'4', :'5', :'6', :'7', :'8', :'9', :'10', :Jack, :Queen, :King, :Ace]
    
    attr_reader :rank_num, :suit, :rank
    
    def initialize(suit=0, rank=2)
        @rank_num = rank
        @suit, @rank = SUITS[suit], RANKS[rank]
    end
    
    def <=>(other)
        @rank_num <=> other.rank_num
    end
    
    def to_s
        "#{@rank} of #{@suit}"
    end
end
