require 'colorize'
require 'singleton'

class Piece
  attr_reader :color, :board, :pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def inspect
    {'class' => self.class, 'color' => color, 'pos' => pos}.inspect
  end

  def to_s
    symbol.to_s.colorize(color)
  end

  def empty?
    self.is_a?(NullPiece)
  end

  def valid_moves
  end

  def pos=(val)
    @pos = val
  end

  def symbol
    raise NotImplementedError
  end

  private
  def move_into_check?(end_pos)
  end
end


module Slideable
  HORIZONTAL_DIRS = [
    [1, 0], [-1, 0],
    [0, 1], [0, -1]
  ]

  DIAGONAL_DIRS = [
    [1, 1],  [1, -1],
    [-1, 1], [-1, -1]
  ]

  def horizontal_dirs
    HORIZONTAL_DIRS
  end

  def diagonal_dirs
    DIAGONAL_DIRS
  end

  def moves
    moves = []
    move_dirs.each do |dr, dc|
      moves += grow_unblocked_moves_in_dir(dr, dc)
    end
    moves
  end

  private
  def move_dirs
    raise NotImplementedError
  end

  def grow_unblocked_moves_in_dir(dr, dc)
    r, c = pos
    new_pos = [r + dr, c + dc]
    moves_in_dir = []

    while board.valid_pos?(new_pos) && board[new_pos].empty?
      moves_in_dir << new_pos
      r, c = new_pos
      new_pos = [r + dr, c + dc]
    end

    if board.valid_pos?(new_pos) && board[new_pos].color != color
      moves_in_dir << new_pos 
    end

    moves_in_dir
  end
end

class Rook < Piece
  include Slideable

  def symbol
    '♜'
  end

  private
  def move_dirs
    horizontal_dirs
  end
end

class Bishop < Piece
  include Slideable

  def symbol
    '♝'
  end

  private
  def move_dirs
    diagonal_dirs
  end
end

class Queen < Piece
  include Slideable

  def symbol
    '♛'
  end

   private
  def move_dirs
    diagonal_dirs + horizontal_dirs
  end
end


module Stepable
  def moves
    moves = []
    move_diffs.each do |dir|
      r , c = pos
      dr, dc = dir
      new_pos = [r + dr, c + dc]
      if board.valid_pos?(new_pos) && 
        (board[new_pos].empty? || board[new_pos].color != color )
        moves << new_pos
      end
    end
    moves
  end

  private
  def move_diffs
  end
end

class Knight < Piece
  include Stepable

  def symbol
    '♞'
  end

  protected
  def move_diffs
    [
      [-2, -1], [-2, 1],
      [-1, -2], [-1, 2],
      [1, -2], [1, 2],
      [2, -1], [2, 1]
    ]
  end
end

class King < Piece
  include Stepable

  def symbol
    '♚'
  end

  protected
  def move_diffs
    [
      [-1, -1],[-1, 0],[-1, 1],
      [0, -1], [0, 1],
      [1, -1], [1, 0], [1, 1]
    ]
  end
end


class Pawn < Piece
  def symbol
    '♟'
  end

  def moves
    r, c = pos
    moves = []

    forward_steps.each do |step|
      new_r = r + (step * forward_dir)
      new_pos = [new_r, c]
      if board.valid_pos?(new_pos) && board[new_pos].empty?
        moves << new_pos
      end
    end

    side_attacks.each do |diag|
      dr, dc = diag
      new_pos = [r + dr, c + dc]

      if board.valid_pos?(new_pos) && 
        !board[new_pos].empty? && board[new_pos].color != color
        moves << new_pos
      end
    end

    moves
  end

  private
  def at_start_row?
    r, c = pos

    if (color == :white && r == 6) ||
      (color == :black && r == 1)
      return true
    else
      return false
    end      
  end

  def forward_dir
    if color == :white
      return -1
    else
      return 1
    end
  end

  def forward_steps
    if at_start_row?
      return [1,2]
    else
      return [1]
    end
  end

  def side_attacks
    [[forward_dir, -1], [forward_dir, 1]]
  end
end

class NullPiece < Piece
  attr_reader :symbol
  include Singleton

  def initialize
    @symbol = " "
    @color = :none
  end

  def moves
    []
  end
end