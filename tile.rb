class Tile
attr_reader :value, :flagged, :bombed, :revealed, :board

  def initialize(value, board)
    @value = value
    @board = board
    @flagged = false
    @bombed = false
    @revealed = false
  end

  def inspect
    { 'value' => @value, 'flagged' => @flagged, 
      'bombed' => @bombed, 'revealed' => @revealed }.inspect
  end

  def value=(new_value)
    @value = new_value
  end

  def toggle_reveal
    @revealed = !@revealed
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
    neighbours.count { |tile| tile.value == "B" }
  end

  # private
  # attr_reader :board
end