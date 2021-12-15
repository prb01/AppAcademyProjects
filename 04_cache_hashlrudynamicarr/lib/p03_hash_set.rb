class HashSet
  attr_reader :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    unless self.include?(key)
      self[key] << key
      @count += 1
    end

    resize! unless num_buckets > count
  end

  def include?(key)
    self[key].include?(key)
  end

  def remove(key)
    if self.include?(key)
      self[key].delete(key) 
      @count -= 1
    end
  end

  private

  def [](key)
    # optional but useful; return the bucket corresponding to `num`
    mod = key.hash % num_buckets
    @store[mod]
  end

  def num_buckets
    @store.length
  end

  def resize!
    num_buckets.times { @store << Array.new }

    store.each_with_index do |subarr, i|
      break if i >= num_buckets / 2

      temp_arr = []
      until subarr.empty?
        temp_arr << subarr.pop
      end

      temp_arr.each do |key|
        self[key] << key
      end
    end
  end
end
