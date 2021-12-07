require_relative 'deck'
require 'set'

class Hand
  attr_reader :hand

  HANDS = {
    1 => "royal flush",
    2 => "straight flush",
    3 => "4 of a kind",
    4 => "full house",
    5 => "flush",
    6 => "straight",
    7 => "3 of a kind",
    8 => "2 pair",
    9 => "1 pair",
    10 => "high card"
  }

  def initialize
    @hand = Set.new
  end

  def length
    @hand.length
  end

  def add(card)
    raise "You have 5 cards already" if self.length >= 5
    @hand << card
  end

  def discard(card, deck)
    raise "You can only discard up to 3 cards" if self.length <= 2
    @hand.delete(card)
    deck.add_card(card)
  end

  def rank
    return 1 if royal_flush?
    return 2 if flush? && straight?
    return 3 if n_of_a_kind? && kinds[0].length == 4
    return 4 if n_of_a_kind? && kinds[0].length == 3 && kinds.length == 2
    return 5 if flush?
    return 6 if straight?
    return 7 if n_of_a_kind? && kinds[0].length == 3
    return 8 if n_of_a_kind? && kinds[0].length == 2 && kinds.length == 2
    return 9 if n_of_a_kind? && kinds[0].length == 2
    return 10
  end

  def maxes
    return [card_values.max] unless n_of_a_kind?

    maxes = []
    kinds.each do |kind|
      maxes << kind.max
    end
    maxes
  end

  def higher_than?(other_hand)
    return true if self.rank < other_hand.rank
    return false if self.rank > other_hand.rank

    maxes.each_with_index do |max, i|
      return true if max > other_hand.maxes[i]
      return false if max < other_hand.maxes[i]
    end

    nil
  end

  private
  def card_values
    values = []
    hand.each { |card| values << card.value }
    values
  end

  def flush?
    suit = hand.to_a[0].suit
    hand.all? { |card| card.suit == suit }
  end

  def straight?
    min = card_values.min
    max = min + 4
    straight = (min..max).to_set

    if max <= 14 && straight.subset?(card_values.to_set)
      return true
    else
      return false
    end
  end

  def royal_flush?
    royal_values = Set[10, 11, 12, 13, 14]

    if flush? && royal_values.subset?(card_values.to_set)
      return true
    else
      return false
    end
  end

  def straight_flush?
    if flush? && straight?
      return true
    else
      return false
    end
  end

  def n_of_a_kind?
    card_values.length != card_values.uniq.length
  end

  def kinds
    return nil unless n_of_a_kind?

    sorted = card_values.sort.reverse
    kinds = []
    temp = []
    (0...sorted.length).each do |i|
      if sorted[i] == sorted[i+1]
        temp << sorted[i]
      elsif sorted[i] == sorted[i-1]
        temp << sorted[i]
        kinds << temp
        temp = []
      else
        kinds << temp unless temp.empty?
        temp = []
      end
    end

    kinds.sort_by! { |array| -array.length }
  end
end