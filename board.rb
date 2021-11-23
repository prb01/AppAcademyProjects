require_relative 'piece'

class Board
  attr_reader :rows

  def initialize
    @rows = Array.new(8) { Array.new(8, nil) } 
    # @null_piece = NullPiece.new()

    @rows = @rows.each_with_index.map do |row, r|
      row.each_with_index.map do |el, c|
        case r
        when 0, 1
          Piece.new(:black, self, [r,c])
        when 6, 7
          Piece.new(:white, self, [r,c])
        else
          nil
        end
      end
    end
  end

  def [](pos)
    r,c = pos
    rows[r][c]
  end

  def []=(pos, val)
    r,c = pos
    rows[r][c] = val
  end

  def move_piece(start_pos, end_pos)
    raise "No piece at start position." if !self[start_pos]
    raise "Cannot move to end position." if !end_pos.all? { |x| (0..7).include?(x) }
    
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    true
  end

  def valid_pos?(pos)
    pos.all? { |x| (0..7).include?(x) }
  end

  def add_piece(piece, pos)
  end

  def checkmate?(color)
  end

  def in_check?(color)
  end

  def find_king(color)
  end

  def pieces
  end

  def dup
  end

  def move_piece!(color, start_pos, end_pos)
  end

  private
  attr_reader :null_piece
end