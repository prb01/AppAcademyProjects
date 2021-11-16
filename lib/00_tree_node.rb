class PolyTreeNode
  attr_reader :parent, :children, :value

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(parent_node)
    parent.remove_child(self) if parent && parent_node
    @parent = parent_node
    parent.add_child(self) if parent
  end

  def add_child(child_node)
    if children.none? { |child| child == child_node } 
      children << child_node
      child_node.parent = self if child_node.parent != self
    end
  end

  def remove_child(child_node)
    raise "Node is not a child" if !children.include?(child_node)
    children.delete_if { |child| child == child_node }
    child_node.parent = nil
  end

  def dfs(target)
    return self if self.value == target
    
    self.children.each do |child|
      search_result = child.dfs(target)
      return search_result if !search_result.nil?
    end
    nil
  end
end