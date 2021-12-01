class Player
  attr_reader :color, :display

  def initialize(color, display)
    @color = color
    @display = display
  end
end

class HumanPlayer < Player
  def make_move(board)
    begin
      start_pos = nil
      end_pos = nil

      while !end_pos
        if !start_pos
          start_pos = display.cursor.get_input
        else
          end_pos = display.cursor.get_input
        end
        display.render
      end

      board.move_piece(color, start_pos, end_pos)
    rescue => e
      puts e.message
      retry
    end
  end
end

class ComputerPlayer < Player
  def make_move(board)
  end
end