# Time = O(n!)
# Space = O(n!)
def first_anagram?(word1, word2)
  anagrams = word1.split("").permutation.to_a.map(&:join)
  anagrams.any? { |anagram| anagram == word2 }
end

# puts first_anagram?("gizmo", "sally")    #=> false
# puts first_anagram?("elvis", "lives")    #=> true
# puts first_anagram?("hippopotamus", "sally")    #=> false
# puts first_anagram?("hippopotamus", "hippopotamus")    #=> true


# Time = O(n^2)
# Space = O(n)
def second_anagram?(word1, word2)
  arr2 = word2.split("")
  word1.each_char do |ch|
    idx = arr2.find_index(ch)
    return false unless idx
    arr2.delete_at(idx)
  end
  arr2.empty?
end

# puts second_anagram?("gizmo", "sally")    #=> false
# puts second_anagram?("elvis", "lives")    #=> true
# puts second_anagram?("hippopotamus", "sally")    #=> false
# puts second_anagram?("hippopotamus", "hippopotamus")    #=> true


# Time = O(n^2) (quick sort worst case; avg is O(n log n))
# Space = O(n)
def third_anagram?(word1, word2)
  word1.split("").sort == word2.split("").sort
end

# puts third_anagram?("gizmo", "sally")    #=> false
# puts third_anagram?("elvis", "lives")    #=> true
# puts third_anagram?("hippopotamus", "sally")    #=> false
# puts third_anagram?("hippopotamus", "hippopotamus")    #=> true
# puts third_anagram?("verylongwordthatseemstohavenoendomgwhenwillthisennndddd", "sally")    #=> false
# puts third_anagram?("verylongwordthatseemstohavenoendomgwhenwillthisennndddd", "verylongwordthatseemstohavenoendomgwhenwillthisennndddd")    #=> true


# Time = O(n)
# Space = O(1) (hash can only have a constant amount of abc's, 26)
# def fourth_anagram?(word1, word2)
#   word_hash1 = Hash.new(0)
#   word_hash2 = Hash.new(0)

#   word1.each_char { |ch| word_hash1[ch] += 1 }
#   word2.each_char { |ch| word_hash2[ch] += 1 }

#   word_hash1 == word_hash2
# end

def fourth_anagram?(word1, word2)
  word_hash = Hash.new(0)

  word1.each_char { |ch| word_hash[ch] += 1 }
  word2.each_char { |ch| word_hash[ch] -= 1 }

  !word_hash.any? { |k, v| v != 0 }
end

puts fourth_anagram?("gizmo", "sally")    #=> false
puts fourth_anagram?("elvis", "lives")    #=> true
puts fourth_anagram?("hippopotamus", "sally")    #=> false
puts fourth_anagram?("hippopotamus", "hippopotamus")    #=> true
puts third_anagram?("verylongwordthatseemstohavenoendomgwhenwillthisennndddd", "sally")    #=> false
puts third_anagram?("verylongwordthatseemstohavenoendomgwhenwillthisennndddd", "verylongwordthatseemstohavenoendomgwhenwillthisennndddd")    #=> true