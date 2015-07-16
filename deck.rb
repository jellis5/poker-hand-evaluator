require_relative 'card'

class Deck
  def initialize
    @cards = []
    (0..3).each do |suit|
      (2..14).each do |rank|
        @cards << Card.new(suit, rank)
      end
    end
  end
  
  def shuffle!
    @cards.shuffle!
  end
  
  def draw_cards(num_cards)
    num_cards.times.inject([]) { |acc, card| acc << @cards.pop }
  end
  
  def to_s
    @cards.inject([]) { |acc, card| acc << card.to_s }.join("\n")
  end
end
