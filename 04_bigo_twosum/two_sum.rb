#Time:  O(n^2)
#Space: O(1)
def bad_two_sum?(arr, target)
  ln = arr.length
  (0...ln-1).each do |i|
    (i+1...ln).each do |j|
      return true if arr[i] + arr[j] == target
    end
  end
  false
end

arr = [0, 1, 5, 7]
# p bad_two_sum?(arr, 6) # => should be true
# p bad_two_sum?(arr, 10) # => should be false


#Time:  O(n log n)
#Space: O(n)
def okay_two_sum?(arr, target)
  sorted = arr.sort
  left = 0
  right = sorted.length - 1

  while left < right
    case (arr[left] + arr[right] <=> target)
    when 0
      return true
    when -1
      left += 1
    when 1
      right -= 1
    end
  end

  false
end

# arr = [0, 1, 5, 7]
# p okay_two_sum?(arr, 6) # => should be true
# p okay_two_sum?(arr, 10) # => should be false
# arr = [0, 2, 10, 4, 8]
# p okay_two_sum?(arr, 6) # => should be true
# p okay_two_sum?(arr, 10) # => should be true


#Time:  O(n)
#Space: O(n)
def two_sum?(arr, target)
  hash = Hash.new
  arr.each do |num|
    return true if hash[target - num]
    hash[num] = true
  end

  false
end

# arr = [0, 1, 5, 7]
# p two_sum?(arr, 6) # => should be true
# p two_sum?(arr, 10) # => should be false
# arr = [0, 2, 10, 4, 8]
# p two_sum?(arr, 6) # => should be true
# p two_sum?(arr, 10) # => should be true