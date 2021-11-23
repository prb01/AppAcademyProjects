class Piece
  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end
end

class Rook < Piece
end

class Bishop < Piece
end

class Queen < Piece
end

class Knight < Piece
end

class King < Piece
end

class Pawn < Piece
end

class NullPiece < Piece
end