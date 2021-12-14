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
    head.next
  end

  def last
    return nil if empty?
    tail.prev
  end

  def empty?
    head.next == tail
  end

  def get(key)
    each { |node| return node.val if key == node.key }
  end

  def include?(key)
    each { |node| return true if key == node.key }
    false
  end

  def append(key, val)
    node = Node.new(key, val)
    node.next = tail
    node.prev = tail.prev
    tail.prev = node
    node.prev.next = node
  end

  def update(key, val)
    each do |node|
      next unless key == node.key
      node.val = val
      break
    end
  end

  def remove(key)
    each do |node|
      next unless key == node.key
      node.remove
      break
    end
  end

  def each(&prc)
    return nil if empty?

    cur_node = first
    until cur_node == tail
      prc.call(cur_node)
      cur_node = cur_node.next
    end
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
