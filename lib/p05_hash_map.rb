require_relative 'p04_linked_list'

class HashMap
  include Enumerable

  attr_reader :store
  attr_accessor :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    if include?(key)
      bucket(key).update(key, val)
    else
      bucket(key).append(key, val)
      @count += 1
    end

    resize! unless num_buckets > count
  end

  def get(key)
    bucket(key).get(key)
  end

  def delete(key)
    if include?(key)
      bucket(key).remove(key)
      @count -= 1
    end
  end

  def each(&prc)
    store.each do |bucket| 
      bucket.each do |node|
        prc.call([node.key, node.val])
      end
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    old_num_buckets = num_buckets
    num_buckets.times { @store << LinkedList.new }

    each do |key, val|
      old_bucket(key, old_num_buckets).remove(key)
      if include?(key)
        bucket(key).update(key, val)
      else
        bucket(key).append(key, val)
      end
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    mod = key.hash % num_buckets
    @store[mod]
  end

  def old_bucket(key, old_num_buckets)
    mod = key.hash % old_num_buckets
    @store[mod]
  end
end
