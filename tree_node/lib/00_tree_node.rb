require 'byebug'
class PolyTreeNode

  attr_reader :children, :value, :parent

  def initialize(value = nil)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(parent_node)
    unless parent.nil?
      parent.children.delete(self)
    end
    @parent = parent_node
    parent_node.children << self if addable_child?(parent_node)

  end

  def addable_child?(parent_node)
    if self.parent.nil? || parent_node.children.include?(self)
      false
    else
      true
    end
  end

  def add_child(child_node)
    child_node.parent=(self)
  end

  def remove_child(child_node)
    unless child_node.parent.children.include?(child_node)
      raise "node is not a child"
    end
    child_node.parent=(nil)
  end

  def dfs(target_value)
    return self if self.value == target_value
    return nil if self.children == []

    self.children.each do |child|
      search_result = child.dfs(target_value)
      return search_result unless search_result.nil?
    end

    nil
  end

  def bfs(target_value)
    queue = [self]

    until queue.empty?
      parent_node = queue.shift

      return parent_node if parent_node.value == target_value

      queue += parent_node.children

    end
    nil
  end
end
