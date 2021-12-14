class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
    self.prev.next = self.next
    self.next.prev = self.prev
    self.next = nil
    self.prev = nil
    self
  end
end

class LinkedList
  include Enumerable

  attr_reader :head, :tail
  def initialize
    @head = Node.new
    @tail = Node.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    return nil if empty?
    self.head.next
  end

  def last
    return nil if empty?
    self.tail.prev
  end

  def empty?
    self.head.next == self.tail
  end

  def get(key)
    each { |node| return node.val if node.key == key }
  end

  def include?(key)
    each { |node| return true if node.key == key }
    false
  end

  def append(key, val)
    node = Node.new(key, val)

    node.next = tail 
    node.prev = tail.prev
    self.tail.prev = node
    node.prev.next = node
    
    node
  end

  def update(key, val)
    each do |node|
      if node.key == key
        node.val = val
        return node
      end
    end
  end

  def remove(key)
    each do |node|
      next unless key == node.key
      node.remove
      return node
    end
  end

  def each
    cur_node = self.head.next
    until cur_node == self.tail
      yield cur_node
      cur_node = cur_node.next
    end
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
