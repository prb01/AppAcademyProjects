require_relative 'piece'

class Board
  attr_reader :rows

  def initialize
    @rows = Array.new(8) { Array.new(8, nil) } 
    # @null_piece = NullPiece.new()

    @rows.each_with_index.map do |row, r|
      row.each_with_index.map do |el, c|
        Piece.new(:red, self, [r,c]) if [0,1,6,7].include?(r)
      end
    end
  end

  def [](pos)
  end

  def []=(pos, val)
  end

  def move_piece(color, start_pos, end_pos)
  end

  def valid_pos?(pos)
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