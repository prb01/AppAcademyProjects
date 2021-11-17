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
    @considered_positions = [start_pos]
    build_move_tree
  end

  def build_move_tree
    queue = [root_node]
    until queue.empty?
      el = queue.shift
      new_move_positions(el.value).each do |move|
        child = PolyTreeNode.new(move)
        child.parent = el
      end
      queue += el.children
    end
  end

  def new_move_positions(pos)
    moves = KnightPathFinder.valid_moves(pos)
    moves.reject! { |move| @considered_positions.include?(move) }
    @considered_positions += moves
    moves
  end

  def find_path
  end
end