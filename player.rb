require_relative 'hand'

class Player
	def initialize(name, chips_amount)
		@name = name
		@hand = Hand.new
		@chips = chips_amount
		@current_bet_amount = 0
	end
	
	attr_reader :name, :hand
	attr_accessor :chips, :current_bet_amount
	
	def take_turn
		raise NotImplementedError, 'take_turn method undefined!'
	end
	
	def to_s
		@name
	end
end
