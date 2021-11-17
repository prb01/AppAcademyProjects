require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    return false if board.over? && 
      (board.tied? || board.winner == evaluator)
    return true if board.over? && board.winner != evaluator

    if next_mover_mark != evaluator
      children.any? do |child|
        child.losing_node?(evaluator)
      end
    else
      children.all? do |child|
        child.losing_node?(evaluator)
      end
    end
  end

  def winning_node?(evaluator)
    return true if board.over? && board.winner == evaluator
    return false if board.over?
    
    if next_mover_mark != evaluator
      children.all? do |child|
        child.winning_node?(evaluator)
      end
    else
      children.any? do |child|
        child.winning_node?(evaluator)
      end
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    children = []
    ln = board.rows.length

    (0...ln).each do |r|
      (0...ln).each do |c|
        pos = [r,c]
        if board.empty?(pos)
          node_board = board.dup
          node_board[pos] = next_mover_mark
          node_next_mark = ((next_mover_mark == :x) ? :o : :x)
          children << TicTacToeNode.new(node_board, node_next_mark, pos)
        end
      end
    end

    children
  end
end