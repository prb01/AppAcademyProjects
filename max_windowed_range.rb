#Time:  O(n^2)
#Space: O(n)
def windowed_max_range(array, window_size)
  current_max_range = nil
  ln = (array.length - window_size)

  (0..ln).each do |i|
    j = (i + window_size) - 1
    min = array[i..j].min
    max = array[i..j].max
    diff = max - min
    current_max_range = diff if !current_max_range || diff > current_max_range
  end

  current_max_range
end

# p windowed_max_range([1, 0, 2, 5, 4, 8], 2) == 4 # 4, 8
# p windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5 # 0, 2, 5
# p windowed_max_range([1, 0, 2, 5, 4, 8], 4) == 6 # 2, 5, 4, 8
# p windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6 # 3, 2, 5, 4, 8

#----------------------------------------------------------------------

class MyQueue
  def initialize
    @store = []
  end

  def peek
    @store.first
  end

  def size
    @store.length
  end

  def empty?
    size == 0
  end

  def enqueue(data)
    @store << data
  end

  def dequeue
    @store.shift
  end
end

class MyStack
  def initialize
    @store = []
  end

  def peek
    @store.last
  end

  def size
    @store.length
  end

  def empty?
    size == 0
  end

  def pop
    @store.pop
  end

  def push(data)
    @store << data
  end
end

class StackQueue
  def initialize
    @store = MyStack.new
    @temp = MyStack.new
  end

  def size
    @store.size + @temp.size
  end

  def empty?
    @store.empty? && @temp.empty?
  end

  def enqueue(data)
    @store.push(data)
  end

  def dequeue
    create_queue if @temp.empty?

    @temp.pop
  end

  private
  def create_queue
    @temp.push(@store.pop) until @store.empty?
  end
end

class MinMaxStack
  def initialize
    @store = MyStack.new
  end

  def peek
    @store.peek[0] unless empty?
  end

  def size
    @store.size
  end

  def empty?
    @store.empty?
  end

  def pop
    popped = @store.pop
  end

  def push(data)
    @store.push([data, new_max(data), new_min(data)])
  end

  def max
    @store.peek[1] unless empty?
  end

  def min
    @store.peek[2] unless empty?
  end

  private
  def new_max(data)
    if self.empty? || data > @store.peek[1]
      max = data
    else
      max = @store.peek[1]
    end
  end

  def new_min(data)
    if self.empty? || data < @store.peek[2]
      min = data
    else
      min = @store.peek[2]
    end
  end
end

class MinMaxStackQueue
  def initialize
    @store = MinMaxStack.new
    @temp = MyStack.new
  end

  def size
    @store.size
  end

  def empty?
    @store.empty?
  end

  def enqueue(data)
    @store.push(data)
  end

  def dequeue
    create_queue if @temp.empty?
    @temp.pop
  end

  def max
    @store.max
  end

  def min
    @store.min
  end

  private
  def create_queue
    @temp.push(@store.pop) until @store.empty?
  end
end

# -------------------------------------------------------------------------

#Time:  O()
#Space: O()
def windowed_max_range(array, window_size)
  current_max_range = nil
  ln = (array.length - window_size)
  queue = MinMaxStackQueue.new

  (0..ln).each do |i|
    window_size.times { |j| queue.enqueue(array[i + j]) }

    min = queue.min
    max = queue.max
    diff = max - min
    current_max_range = diff if !current_max_range || diff > current_max_range
    
    window_size.times { |j| queue.dequeue }
  end

  current_max_range
end

p windowed_max_range([1, 0, 2, 5, 4, 8], 2) == 4 # 4, 8
p windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5 # 0, 2, 5
p windowed_max_range([1, 0, 2, 5, 4, 8], 4) == 6 # 2, 5, 4, 8
p windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6 # 3, 2, 5, 4, 8