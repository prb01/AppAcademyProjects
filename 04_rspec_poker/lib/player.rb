require_relative 'hand'

class Player
  attr_reader :name, :pot, :hand, :folded, :called, :raised, :cur_bet

  def initialize(name, pot = 100, hand = Hand.new)
    @name = name
    @pot = pot
    @cur_bet = 0
    @hand = hand
    @folded = false
    @called = false
    @raised = false
  end

  def bet(amt)
    change_pot(-amt)
    @cur_bet = amt
  end

  def reset_round
    @bet = 0
    @called = false
    @raised = false
  end

  def reset_match
    reset_round
    @folded = false
    @hand = Hand.new
  end

  def change_pot(amt)
    new_pot = @pot + amt
    raise ArgumentError.new("Not enough in the pot.") if new_pot < 0
    @pot = new_pot
    amt
  end

  def take_card(card)
    @hand.add(card)
  end

  def display_hand
    puts
    puts hand_arr.join(" ")
    puts " #{(0..4).to_a.join("   ")}"
  end

  def get_discards
    begin
      puts "#{name} choose up to 3 cards to discard"
      puts "(use commas to separate selected cards, e.g. '0,3,4')"
      puts "(hit ENTER once done or if not discarding any cards)"

      input = gets.chomp.split(",").map(&:to_i)
      valid_discards?(input)
    rescue => e
      print "\nERROR: #{e.message}\n\n"
      sleep(1)
      retry
    end

    discards = []
    input.each { |idx| discards << hand_arr[idx] }
    discards
  end

  def valid_discards?(discards)    
    unless discards.all? { |discard| (0..4).to_a.include?(discard) }
      raise ArgumentError.new("Invalid input. Please ensure only numbers are entered in range.")
    end

    raise ArgumentError.new("Too many discards selected") if discards.length > 3
  end

  def discard(cards, deck)
    cards.each do |card|
      hand.discard(card, deck)
    end
  end

  def get_move
    begin
      puts "#{name} enter your move: fold (f), call (c), raise (r)"
      move = gets.chomp.downcase
      valid_move?(move)
    rescue => e
      print "\nERROR: #{e.message}\n\n"
      sleep(1)
      retry
    end

    move
  end

  def valid_move?(move)
    unless ["fold", "f", "call", "c", "raise", "r"].include?(move)
      raise ArgumentError.new("Invalid move. Please try again.")
    end
  end

  def get_raise
    begin
      puts "#{name} enter the raised amount you wish to bet"
      amt = gets.chomp.to_i
      valid_raise?(amt)
    rescue => e
      print "\nERROR: #{e.message}\n\n"
      sleep(1)
      retry
    end

    amt
  end

  def valid_raise?(amt)
    raise ArgumentError.new("Can't raise more than your pot") if amt > pot
  end

  def parse_move(move, bet)
    case move
    when 'fold', 'f'
      @folded = true
      return 0
    when 'call', 'c'
      bet(bet)
      @called = true
      @raised = false
      return bet
    when 'raise', 'r'
      raise_amt = get_raise
      bet(raise_amt)
      @called = false
      @raised = true
      return raise_amt
    end
  end

  def toggle_called
    @called = !called
  end

  private
  def hand_arr
    hand.hand.to_a
  end
end