require 'colorize'
require_relative 'board'
require_relative 'cursor'

class Display
  attr_reader :board, :cursor

  def initialize(debug_info = false, board = Board.new)
    @board = board
    @cursor = Cursor.new([0,0], board)
    @debug_info = debug_info
  end

  def render
    white_bg = true
    
    system("clear")
    puts "   #{('a'..'h').to_a.join("  ")}  "

    board.rows.each_with_index do |rows, r|
      row_str = "#{r} "
      rows.each_with_index do |el, c|

        if [r,c] == cursor.cursor_pos
          row_str += " #{board[[r,c]]} ".on_light_magenta.blink
          white_bg = !white_bg
          next
        end

        if white_bg
          row_str += " #{board[[r,c]]} ".on_light_cyan
          white_bg = !white_bg
        else
          row_str += " #{board[[r,c]]} ".on_blue
          white_bg = !white_bg
        end

      end

      puts "#{row_str} #{r}"
      white_bg = !white_bg
    end

    puts "   #{('a'..'h').to_a.join("  ")}  "

    debug_render if debug_info
  end

  private
  attr_reader :debug_info

  def debug_render
    piece = board[cursor.cursor_pos]
    puts "#{piece.color} #{piece.class} @ #{cursor.cursor_pos}"

    if [:white, :black].include?(piece.color)
      puts "moves: #{piece.moves}"
      puts "v_mov: #{piece.valid_moves}"
      puts "check? #{board.in_check?(piece.color)}"
      puts "cmate? #{board.checkmate?(piece.color)}"
    end
  end
end