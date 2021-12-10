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

  while left <= right
    mid = ((left + right) / 2).floor

    if sorted[mid] + sorted[mid-1] < target
      left = mid + 1
    elsif sorted[mid] + sorted[mid-1] > target
      right = mid - 1
    elsif sorted[mid] + sorted[mid-1] == target
      return true
    end
  end

  false
end

arr = [0, 1, 5, 7]
# p okay_two_sum?(arr, 6) # => should be true
# p okay_two_sum?(arr, 10) # => should be false
arr = [0, 2, 10, 4, 8]
# p okay_two_sum?(arr, 6) # => should be true
# p okay_two_sum?(arr, 10) # => should be true


#Time:  O(n)
#Space: O(1)
def two_sum?(arr, target)
  hash = Hash.new
  arr.each do |num|
    hash[num] = (num <= target)
  end
  
  (0..(target/2.0).ceil-1).each do |i|
    return true if hash[i] && hash[target - i]
  end

  false
end

arr = [0, 1, 5, 7]
p two_sum?(arr, 6) # => should be true
p two_sum?(arr, 10) # => should be false
arr = [0, 2, 10, 4, 8]
p two_sum?(arr, 6) # => should be true
p two_sum?(arr, 10) # => should be true