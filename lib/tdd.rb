class Array
  def my_uniq
    my_uniq = []
    self.each { |el| my_uniq << el unless my_uniq.include?(el) }
    my_uniq
  end

  def two_sum
    two_sum = []
    self.each_with_index do |el1, idx1|
      self.each_with_index do |el2, idx2|
        two_sum << [idx1, idx2] if (el1 + el2 == 0) && (idx2 > idx1)
      end
    end

    two_sum
  end

  def my_transpose
    transposed = []

    (0...self.length).each do |i|
      temp_arr = []
      (0...self.length).each { |j| temp_arr << self[j][i] }
      transposed << temp_arr
    end

    transposed
  end

  def stock_picker
    low, high = nil

    self.each_with_index do |price, idx|
      low = idx if !low || (self[low] > price)
      high = idx if low && idx > low && (!high || price > self[high])
    end

    raise 'Stock bought at highest price' if high == nil
    days = [low, high]
  end
end

class Hanoi

end

class Board
  attr_reader :size, :board

  def initialize(size = 4)
    @size = size
    @board = Array.new(3) { Array.new }
    populate_board
  end

  def move_disc(idx1, idx2)
    if valid_move?(idx1, idx2)
      val = @board[idx1].pop
      @board[idx2] << val
    end
  end

  def won?
    win_stack = (1..size).to_a.reverse
    return true if @board[-1] == win_stack
    false
  end

  private
  def populate_board
    (1..size).each do |i|
      @board[0].unshift(i)
    end
  end

  def valid_move?(idx1, idx2)
    if (0..2).to_a.include?(idx1) &&
      (0..2).to_a.include?(idx2) &&
      (@board[idx2].empty? || @board[idx1][-1] < @board[idx2][-1])
      return true
    else
      return false
    end
  end
end

class Player
  def initialize(name)
    @name = name
  end

  def make_move

  end
end