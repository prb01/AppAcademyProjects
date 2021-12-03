  class Card
    attr_reader :suit, :value, :color, :symbol

    SYMBOLS = {
      "heart" => ["♥", :red],
      "diamond" => ["♦", :red],
      "spade" => ["♠", :black],
      "club" => ["♣", :black]
    }

    VALUES = {
      11 => "J",
      12 => "Q",
      13 => "K",
      14 => "A"
    }

    def initialize(suit, value)
      raise ArgumentError.new("Invalid suit") unless SYMBOLS.keys.include?(suit)
      raise ArgumentError.new("Invalid value") unless (1..14).include?(value)

      @suit = suit
      @value = value > 10 ? VALUES[value] : value
      @symbol = SYMBOLS[suit][0]
      @color = SYMBOLS[suit][1]
    end
  end