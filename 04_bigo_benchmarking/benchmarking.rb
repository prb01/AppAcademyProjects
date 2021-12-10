require 'benchmark'
require_relative '../04_bigo_anagrams/anagrams'


["a"*2, "a"*4, "a"*8, "a"*10].each do |word|
  puts word
  Benchmark.bm(7) do |x|
    x.report("first:") {first_anagram?(word, "sally")}
    x.report("second:") {second_anagram?(word, "sally")}
    x.report("third:") {third_anagram?(word, "sally")}
    x.report("fourth:") {fourth_anagram?(word, "sally")}
  end
  puts
end

puts "-----------------------------------"
puts "excluding first_anagram? O(n!)"
puts
["a"*10000, "a"*100000, "a"*1000000].each do |word|
  word2 = word + "b"
  Benchmark.bm(7) do |x|
    x.report("second:") {second_anagram?(word, word2)}
    x.report("third:") {third_anagram?(word, word2)}
    x.report("fourth:") {fourth_anagram?(word, word2)}
  end
  puts
end