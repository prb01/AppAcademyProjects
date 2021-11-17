require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    node_mark = ((mark == :x) ? :o : :x)
    node = TicTacToeNode.new(game.board, mark)
    winner = nil
    non_loser = nil

    node.children.each do |child|
      return child.prev_move_pos if child.winning_node?(mark) && !child.losing_node?(mark)
      non_loser = child.prev_move_pos if !child.losing_node?(mark)
    end

    raise "No non-losers. What the bejesus?" if non_loser.nil?
    return non_loser
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
