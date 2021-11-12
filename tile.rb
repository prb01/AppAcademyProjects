class Tile
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
end