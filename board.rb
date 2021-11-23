require_relative 'piece'

class Board
  attr_reader :rows

  def initialize
    @rows = Array.new(8) { Array.new(8, nil) } 
    @null_piece = NullPiece.instance

    @rows = @rows.each_with_index.map do |row, r|
      row.each_with_index.map do |el, c|
        case r
        when 0
          case c
          when 0, 7
            Rook.new(:black, self, [r,c])
          when 1, 6
            Knight.new(:black, self, [r,c])
          when 2, 5
            Bishop.new(:black, self, [r,c])
          when 3
            Queen.new(:black, self, [r,c])
          when 4
            King.new(:black, self, [r,c])
          end
        when 1
          Pawn.new(:black, self, [r,c])
        when 6
          Pawn.new(:white, self, [r,c])
        when 7
          case c
          when 0, 7
            Rook.new(:white, self, [r,c])
          when 1, 6
            Knight.new(:white, self, [r,c])
          when 2, 5
            Bishop.new(:white, self, [r,c])
          when 3
            Queen.new(:white, self, [r,c])
          when 4
            King.new(:white, self, [r,c])
          end
        else
          null_piece
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

  def move_piece(color, start_pos, end_pos)
    if !valid_pos?(start_pos) || (self[start_pos] == null_piece)
      raise "No piece at start position."
    elsif !self[start_pos].moves.include?(end_pos)
      raise "Cannot move to end position."
    end
    
    self[end_pos] = self[start_pos]
    self[start_pos] = null_piece
    self[end_pos].pos = end_pos
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