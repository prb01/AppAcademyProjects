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

  def take_card
    @cards.pop
  end

  def add_card(card)
    raise ArgumentError.new("Card is not valid") unless valid_card?(card)
    @cards.unshift(card)
  end

  private
  def valid_card?(card)
    if card.is_a?(Card) &&
      ( self.cards.none? { |c| c.value == card.value && c.suit == card.suit })
      return true
    else
      return false
    end
  end
end