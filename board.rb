require_relative 'tile'

class Board
  # def self.create_board(size, bombs)
  #   board = Array.new(size) { Array.new(size) }
  #   board.each do |rows|
  #   Tile.new(0, board)
  #   board = Board.populate_bombs(board, bombs)
  # end

  # def self.populate_bombs(board, bombs)
  #   until bombs == 0
  #     row = rand(0...board.count)
  #     col = rand(0...board.count)
  #     if board[row][col] != "B"
  #       board[row][col].value = "B"
  #       bombs -= 1
  #     end
  #   end
  #   board
  # end

  attr_reader :board

  def initialize(size = 9)
    @board = Array.new(size) { Array.new(size) }
    @board.each do |rows|
      rows.map! { |el| el = Tile.new(0, board) }
    end
    populate_bombs()
  end

  def populate_bombs(bombs = 10)
    until bombs == 0
      row = rand(0...board.count)
      col = rand(0...board.count)
      if board[row][col] != "B"
        board[row][col].value = "B"
        bombs -= 1
      end
    end
  end

  def [](pos)
    row, col = pos
    board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    tile = board[row][col]
    tile.value = value
  end
end