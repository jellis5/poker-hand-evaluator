require_relative 'hand'
require_relative 'chips'

class Player
	def initialize(name, chips_amount)
		@name = name
		@hand = Hand.new
		@chips = Chips.new(chips_amount)
	end
	
	attr_reader :name, :hand
	attr_accessor :chips
	
	def take_turn
		raise NotImplementedError, 'take_turn method undefined!'
	end
	
	def to_s
		@name
	end
end