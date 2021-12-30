# @param {String} s
# @return {Integer}
def length_of_longest_substring(s)
    hash = Hash.new(nil)
    longest_ln = 0
    current_ln = 0
    i = 0
    start_count = 0
    last_offender = 0

    while i < s.length
        puts "-------"
        puts s[i]
        if hash[s[i]]
            puts "if"
            puts longest_ln = current_ln if current_ln > longest_ln
            puts last_offender = hash[s[i]] if hash[s[i]] > last_offender
            puts current_ln -= (last_offender - start_count + 1)
            puts start_count = last_offender + 1
            # hash[s[i]] = nil
            puts hash[s[i]]
            print hash.values
            hash.reject! { |k,v| v <= last_offender }
            break if i == s.length - 1
        else
            puts "else"
            puts current_ln += 1
            hash[s[i]] = i
            i += 1
        end
    end

    longest_ln = current_ln if current_ln > longest_ln
    return longest_ln
end

p length_of_longest_substring("abba") == 2
p length_of_longest_substring("tmmzuxt") == 5
p length_of_longest_substring("aabaab!bb") == 3
