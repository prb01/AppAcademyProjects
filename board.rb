require_relative 'tile'
require 'colorize'

class Board
  BOMB = :B
  FLAG = :F

  def self.create_board(size, bombs)
    board = Array.new(size) { Array.new(size) }
    board.each do |rows|
      rows.map! { |tile| tile = Tile.new("_", board) }
    end
    board = Board.populate_bombs(board, bombs)
  end

  def self.populate_bombs(board, bombs)
    until bombs == 0
      row = rand(0...board.count)
      col = rand(0...board.count)
      if board[row][col] != BOMB
        board[row][col].value = BOMB
        bombs -= 1
      end
    end
    board
  end

  attr_reader :board

  def initialize(board = Board.create_board(9,10))
    @board = board
  end

  def size
    board.count
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

  def hidden_board
    board.map do |row|
      row.map do |tile|
        if tile.revealed || tile.flagged
          tile.to_s
        # elsif tile.flagged
        #   FLAG
        else
          "*"
        end
      end
    end
  end

  def render
    system("clear")
    puts "  #{(0...size).to_a.join(" ")}".colorize(:light_blue)
    hidden_board.each_with_index do |row, i|
      puts "#{i.to_s.colorize(:light_blue)} #{row.map(&:to_s).join(" ")}"
    end
  end

  def solved?
    revealed? && !bombed?
  end

  def revealed?
    bombless_board = []
    board.each do |row|
      row.each do |tile| 
        bombless_board << tile if tile.value != BOMB
      end
    end

    bombless_board.all? { |tile| tile.revealed }
  end

  def bombed?
    board.any? do |row|
      row.any? { |tile| tile.bombed }
    end
  end

  def toggle_reveal_all
    board.each do |row|
      row.each do |tile|
        tile.reveal
      end
    end
  end

  def reveal_all
    board.each do |row|
      row.each do |tile|
        tile.toggle_flagged until !tile.flagged
        tile.reveal until tile.revealed
      end
    end
  end
end