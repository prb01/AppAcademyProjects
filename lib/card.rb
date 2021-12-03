  class Card
    attr_reader :suit, :value, :face, :color, :symbol

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

    def self.symbols
      SYMBOLS
    end

    def initialize(suit, value)
      raise ArgumentError.new("Invalid suit") unless SYMBOLS.keys.include?(suit)
      raise ArgumentError.new("Invalid value") unless (2..14).include?(value)

      @suit = suit
      @value = value
      @face = value > 10 ? VALUES[value] : nil
      @symbol = SYMBOLS[suit][0]
      @color = SYMBOLS[suit][1]
    end
  end