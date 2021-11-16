class PolyTreeNode
  attr_reader :parent, :children, :value

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(new_parent)
    parent.children.delete_if { |child| child == self } if parent
    @parent = new_parent
    parent.add_child(self) if parent
  end

  def add_child(new_child)
    if children.none? { |child| child == new_child } 
      children << new_child
      new_child.parent = self if new_child.parent != self
    end
  end

  def remove_child(old_child)
    raise "Node is not a child" if !children.include?(old_child)
    old_child.parent = nil
    children.delete_if { |child| child == old_child }
  end

end