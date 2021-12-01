require_relative 'board'
require_relative 'display'
require_relative 'player'

class Game
  attr_reader :board, :display, :players, :cur_player
  def initialize
    @board = Board.new
    @display = Display.new(false, board)
    @players = [HumanPlayer.new(:white, display), 
                HumanPlayer.new(:black, display)]
    @cur_player = players[0]
  end

  def play
    while [:white, :black].none? { |color| board.checkmate?(color) }
      display.render
      notify_players
      cur_player.make_move(board)
      swap_turn!
    end

    display.render
    swap_turn!
    puts "#{cur_player.color} wins!"
  end

  private
  def notify_players
    puts "#{cur_player.color}'s turn to move."
    puts "Please use W,A,S,D to move cursor and ENTER to choose"
  end

  def swap_turn!
    @cur_player = @cur_player == players[0] ? players[1] : players[0]
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end