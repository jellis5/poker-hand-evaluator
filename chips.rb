class Chips

	attr_accessor :amount
	
	def initialize(amount)
		@amount = amount
	end
	
	def <(other)
		@amount < (other.is_a?(Chips) ? other.amount : other)
	end
	
	def >(other)
		@amount > (other.is_a?(Chips) ? other.amount : other)
	end
	
	def ==(other)
		@amount == (other.is_a?(Chips) ? other.amount : other)
	end
	
	def to_s
		"Number of chips: #{@amount}"
	end
end
