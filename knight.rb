require_relative '04_data_polytreenode/lib/00_tree_node.rb'

class KnightPathFinder
  DELTAS = [
    [-2,-1], [-2,1],
    [-1,2],  [1,2],
    [2,1],   [2,-1],
    [1,-2],  [-1,-2],
  ]

  def self.valid_moves(pos)
    r,c = pos
    moves = DELTAS.map do |delta|
      dr,dc = delta
      [r + dr, c + dc]
    end

    moves.reject! do |move|
      move.any? { |x| !(0..7).include?(x) }
    end

    moves
  end

  attr_reader :root_node

  def initialize(start_pos)
    @root_node = PolyTreeNode.new(start_pos)
    build_move_tree
  end

  def build_move_tree
  end

  def find_path
  end
end