require 'byebug'
require 'colorize'

class Tile
  BOMB = :B
  FLAG = :F

  attr_reader :value, :flagged, :bombed, :revealed

  def initialize(value, board)
    @value = value
    @board = board
    @flagged = false
    @bombed = false
    @revealed = false
  end

  def inspect
    { 'object_id' => self.object_id, 'value' => @value, 'flagged' => @flagged, 
      'bombed' => @bombed, 'revealed' => @revealed }.inspect
  end

  def value=(new_value)
    @value = new_value
  end

  def toggle_flagged
    @flagged = !@flagged
  end

  def bomb
    @bombed = true
  end

  def color
    return :green if flagged
    return :red if value == BOMB
  end

  def to_s
    flagged ? FLAG.to_s.colorize(color) : value.to_s.colorize(color)
  end

  def reveal
    if !flagged && !revealed
      @revealed = true
      if value == BOMB && revealed
        bomb
        return
      end
      @value = neighbour_bomb_count == 0 ? " " : neighbour_bomb_count
      reveal_neighbours if value == " "
    elsif flagged
      puts "Unflag before trying to reveal"
      sleep(2)
    end
  end

  def my_pos
    board.each_with_index do |rows, row|
      rows.each_with_index do |tiles, col|
        return [row, col] if self == tiles
      end
    end
    nil
  end

  def my_row
    row, col = my_pos
    row
  end

  def my_col
    row, col = my_pos
    col
  end

  def neighbours
    arr = []
    (-1..1).each do |row|
      (-1..1).each do |col|
        next if row == 0 && col == 0

        pos = [my_row + row, my_col + col]
        new_row, new_col = pos
        if valid_pos?(pos)
          arr << board[new_row][new_col]
        else
          arr << nil
        end
      end
    end
    arr
  end

  def valid_pos?(pos)
    if pos.is_a?(Array) &&
      pos.length == 2 &&
      pos.all? { |x| x >= 0 && x < board.count }
      return true
    else
      return false
    end
  end

  def neighbour_bomb_count
    neighbours.count { |tile| tile.value == BOMB if tile }
  end

  def reveal_neighbours
    neighbours.each {|neighbour| neighbour.reveal if neighbour }
  end

  private
  attr_reader :board
end