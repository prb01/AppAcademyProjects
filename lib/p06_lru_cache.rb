require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :map, :store, :max, :prc

  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if map.include?(key)
      node = map[key]
      update_node!(node)
      node.val
    else
      eject! if count >= max
      calc!(key)
    end
  end

  def to_s
    'Map: ' + @map.to_s + '\n' + 'Store: ' + @store.to_s
  end

  alias_method :inspect, :to_s

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    val = prc.call(key)
    map[key] = store.append(key, val)
    val
  end

  def update_node!(node)
    # suggested helper method; move a node to the end of the list
    node.prev.next = node.next
    node.next.prev = node.prev
    node.next = store.tail
    node.prev = store.tail.prev
    store.tail.prev = node
    node.prev.next = node

    node
  end

  def eject!
    key = store.first.key
    store.first.remove
    map.delete(key)
  end
end
