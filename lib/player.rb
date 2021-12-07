require_relative 'hand'

class Player
  attr_reader :name, :pot, :hand

  def initialize(name, pot = 100)
    @name = name
    @pot = pot
    @hand = Hand.new
  end

  def change_pot(amt)
    new_pot = @pot + amt
    raise ArgumentError.new("Not enough in the pot.") if new_pot < 0
    @pot = new_pot
  end

  
end