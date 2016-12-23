require_relative '00_tree_node'

class KnightPathFinder

  attr_reader :visited_positions, :start_pos, :root

#due to likely differences in DELTAS with solution, path may be different
#than solution, but path is still viable
  DELTAS = [
    [2,-1], [1,2],
    [-2,-1], [-2, 1],
    [-1, 2], [2,1],
    [-1, -2], [1, -2]
  ]

  BOARD_LENGTH = 8

  def self.valid_moves(pos)
    good_moves = DELTAS.map do |delta|
      delta.map.with_index do |coord, idx|
        pos[idx]+coord
      end
    end

    better_moves = good_moves.select do |move|
      move if (move[0] >= 0 && move[1] >= 0) &&
      (move[0] < BOARD_LENGTH && move[1] < BOARD_LENGTH)
    end
  end

  def initialize(start)
    @start_pos = start
    #@path = build_move_tree
    @visited_positions = [start_pos]
  end

  def build_move_tree
    @root = PolyTreeNode.new(start_pos)

    queue = [@root]

    until queue.empty?
      parent_node = queue.shift
      self.class.valid_moves(parent_node.value).each do |position|
        next if visited_positions.include?(position)
        node = PolyTreeNode.new(position)
        queue << node
        visited_positions << position
        node.parent = parent_node
      end

    end

  end

# methods to gather all solving methods in one procedure
  def run_solver

    print 'Enter target position: '
    target = gets.chomp.split(",").map(&:to_i)
    build_move_tree
    find_path(target)
    p trace_path_back(@end_node)

  end

  def find_path(end_pos)
    #bfs
    @end_node = @root.bfs(end_pos)
  end

  def trace_path_back(last_node)
    path = []
    current_node = last_node
    until current_node.parent.nil?
      path << current_node.value
      current_node = current_node.parent
    end
    path << current_node.value
    path.reverse
  end

  def new_move_positions(pos)
    possible_moves = self.valid_moves(pos)
    new_moves = possible_moves.select do |move|
      move unless visited_positions.include?(pos)
    end

    visited_positions += new_moves
    visited_positions
  end


end

if __FILE__ == $PROGRAM_NAME
  kpf1 = KnightPathFinder.new([0,0])
  kpf2 = KnightPathFinder.new([0,0])

  kpf1.run_solver
  kpf2.run_solver
end
