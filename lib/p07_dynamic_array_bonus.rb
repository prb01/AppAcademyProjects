class StaticArray
  attr_reader :store

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    self.store[i]
  end

  def []=(i, val)
    validate!(i)
    self.store[i] = val
  end

  def length
    self.store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, self.store.length - 1)
  end
end

class DynamicArray
  include Enumerable

  attr_reader :store
  attr_accessor :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    return nil if i < -self.count
    return nil if i >= self.count

    i = i >= 0 ? i : (self.count + i)
    @store[i]
  end

  def []=(i, val)
    return nil if i < -self.count
    
    if i >= self.count
      (i - self.count).times { self.push(nil) }
    end
    i = i >= 0 ? i : (self.count + i)

    if i == count
      resize! if capacity == self.count
      self.count += 1
    end

    @store[i] = val
  end

  def capacity
    @store.length
  end

  def include?(val)
    self.each { |el| return true if el == val }
    false
  end

  def push(val)
    self.resize! if count == capacity

    self.store[count] = val
    self.count += 1
    val
  end

  def unshift(val)
    self.resize! if count == capacity

    self.count.downto(1).each { |i| self.store[i] = self.store[i-1] }     
    self.store[0] = val
    self.count += 1
    val
  end

  def pop
    return nil if count == 0

    val = self.last
    self[count-1] = nil
    self.count -= 1
    val
  end

  def shift
    return nil if count == 0

    val = self.first
    (1...count).each { |i| self.store[i-1] = self.store[i] }
    self[count - 1] = nil
    self.count -= 1
    val
  end

  def first
    self[0]
  end

  def last
    self[count - 1]
  end

  def each
    i = 0
    while i < count
      yield self[i]
      i += 1
    end
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def inspect
    @store.store
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false if self.count != other.count
    self.each_with_index { |el, i| return false if self[i] != other[i] }

    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  # private

  def resize!
    old_store = store
    @store = StaticArray.new(capacity * 2)
    @count = 0

    (0...old_store.length).each do |i|
      self << old_store[i]
    end
  end
end
