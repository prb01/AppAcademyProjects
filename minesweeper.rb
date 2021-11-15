require_relative 'board'

class MineSweeper
  VALID_VALS = ["F", "C"]

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
      puts "ENTER to reveal or F to flag. C to change position."
      print "> "
      val = gets.chomp
    end

    val
  end

  def valid_val?(val)
    if val.length <= 1 &&
      ( VALID_VALS.include?(val.upcase) || val.empty? )
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
    board.render(board.hidden_board)
    pos = get_pos
    val = get_val
    case val.upcase
    when "F"
      board[pos].toggle_flagged
    when ""
      board[pos].reveal
    when "C"
      play_turn
    end
  end

  def run
    play_turn until solved? || lost?
    board.render(board.show_board)
    if solved?
      puts "Congratulations on solving!"
    else
      puts "Sorry, you lost!"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  game = MineSweeper.new()
  game.run
end