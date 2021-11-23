require_relative 'piece'

class Board
  attr_reader :rows

  def initialize
    @null_piece = NullPiece.instance
    reset_board
  end

  def [](pos)
    r,c = pos
    rows[r][c]
  end

  def []=(pos, val)
    r,c = pos
    rows[r][c] = val
  end

  def move_piece(color, start_pos, end_pos)
    if !valid_pos?(start_pos) || (self[start_pos] == null_piece)
      raise "No piece at start position."
    elsif !self[start_pos].moves.include?(end_pos)
      raise "Cannot move to end position."
    end
    
    move_piece!(color, start_pos, end_pos)
  end

  def move_piece!(color, start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = null_piece
    self[end_pos].pos = end_pos
    true
  end

  def valid_pos?(pos)
    pos.all? { |x| (0..7).include?(x) }
  end

  def add_piece(piece, pos)
    self[pos] = piece
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

  private
  attr_reader :null_piece

  def fill_back_row(color)
    back_pieces = [
      Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook
    ]

    r = color == :black ? 0 : 7

    back_pieces.each_with_index do |piece, c|
      piece.new(color, self, [r, c])
    end
  end

  def fill_pawn_row(color)
    r = color == :black ? 1 : 6

    (0..7).each do |c|
      Pawn.new(color, self, [r, c])
    end
  end

  def reset_board
    @rows = Array.new(8) { Array.new(8, null_piece) }
    [:white, :black].each do |color|
      fill_back_row(color)
      fill_pawn_row(color)
    end
  end
end