require 'colorize'
require_relative 'board'
require_relative 'cursor'

class Display
  attr_reader :board, :cursor

  def initialize(board = Board.new)
    @board = board
    @cursor = Cursor.new([0,0], board)
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
  end
end

# if __FILE__ == $PROGRAM_NAME
#   display = Display.new
#   while true
#     display.render
#     display.cursor.get_input
#   end
# end