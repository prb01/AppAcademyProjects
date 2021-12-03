require_relative 'card'

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    Card.symbols.keys.each do |suit|
      (2..14).each do |value|
        @cards << Card.new(suit, value)
      end
    end
  end

  def shuffle!
    @cards.shuffle!
  end
end