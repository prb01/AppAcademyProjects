require_relative '../04_data_polytreenode/lib/00_tree_node.rb'

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

  def find_path(end_pos)
    end_node = root_node.bfs(end_pos)
    return trace_path_back(end_node) if end_node
    nil
  end

  def trace_path_back(node)
    return [node.value] if !node.parent
    path = trace_path_back(node.parent) + [node.value]
  end

  def render(pos)
    board = Array.new(8) { Array.new(8, " ") }
    r,c = pos
    board[r][c] = "K"

    system("clear")

    puts "  #{(0..7).to_a.join("|")}|"
    board.each_with_index do |row, i|
      puts "#{i}|#{row.join("|")}|"
    end
  end

  def render_path(path)
    path.each_with_index do |pos, i|
      render(pos)
      puts "path: #{path}"
      puts "move: #{i}"
      sleep(2)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  kpf = KnightPathFinder.new([0,0])
  kpf.render_path(kpf.find_path([1,1]))
  kpf.render_path(kpf.find_path([7,7]))
end
