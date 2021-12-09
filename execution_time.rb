def my_min_1(list) #=> O(n^2)
  list.each do |num1|
    min = true

    list.each do |num2|
      min = false if num2 < num1
    end

    return num1 if min
  end
end

def my_min_2(list) #=> O(n)
  min = list[0]
  list.each { |num| min = num if num < min }
  min
end

list = [ 0, 3, 5, 4, -5, 10, 1, 90 ]
puts my_min_1(list)
puts my_min_2(list)

#----------------------------------------------------------------------------

def largest_contiguous_subsum_1(list) #=> O(n!)
  subs = []
  (0...list.length).each do |i|
    (i...list.length).each do |j|
      subs << list[i..j]
    end
  end

  max = subs[0].sum
  subs.each do |sub|
    max = sub.sum if sub.sum > max
  end

  max
end

def largest_contiguous_subsum_2(list)
  cur_sum = 0
  max_sum = list[0]

  list.each do |num|
    cur_sum += num
    cur_sum = num if num > cur_sum
    max_sum = cur_sum if cur_sum > max_sum
  end

  max_sum
end

# list = [5, 3, -7] #=> 8
list = [2, 3, -6, 7, -6, 7] # => 8
# list = [-5, -1, -3] #=> -1
puts largest_contiguous_subsum_1(list)
puts largest_contiguous_subsum_2(list)