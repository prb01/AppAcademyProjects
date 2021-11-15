require_relative 'board'

class MineSweeper
  attr_reader :board

  def initialize(board = Board.new())
    @board = board
  end

  def size
    board.size
  end

  def get_pos
    pos = nil
    until pos && valid_pos?(pos)
      puts "Please enter a position on the board (e.g. 3,5)"
      print "> "

      begin
        pos = parse_pos(gets.chomp)
      rescue
        puts "Invalid position entered. Did you enter 2 numbers separated by commas?"
        puts ""

        pos = nil
      end
    end

    pos
  end

  def parse_pos(string)
    string.split(",").map! { |char| Integer(char) }
  end

  def valid_pos?(pos)
    if pos.is_a?(Array) &&
      pos.length == 2 &&
      pos.all? { |x| (0...size).include?(x) }
      return true
    else
      return false
    end
  end

  def get_val
    val = nil
    until val && valid_val?(val)
      puts "ENTER to reveal or F to flag"
      print "> "
      val = gets.chomp
    end

    val
  end

  def valid_val?(val)
    if val.length <= 1 &&
      ( val.upcase == "F" || val.empty? )
      return true
    else
      return false
    end
  end

  def solved?
    board.solved?
  end

  def lost?
    board.bombed?
  end

  def play_turn
    board.render
    pos = get_pos
    val = get_val
    case val.upcase
    when "F"
      board[pos].toggle_flagged
    when ""
      board[pos].reveal
    end
  end

  def run
    play_turn until solved? || lost?
    board.reveal_all
    board.render
    if solved?
      puts "Congratulations on solving!"
    else
      puts "Sorry, you lost!"
    end
  end
end

game = MineSweeper.new()
game.run