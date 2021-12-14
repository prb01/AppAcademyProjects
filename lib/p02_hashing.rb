class Integer
  # Integer#hash already implemented for you
end

class Array
  def hash
    return 0.to_s(8).to_i if self.empty?

    ln = self.length
    xor_num = self.first.to_s.unpack("c*").sum

    (0...ln).each do |i|
      xor_num = xor_num ^ (self[i].to_s.unpack("c*").sum * i)
    end

    xor_num.hash
  end
end

class String
  def hash
    self.split("").hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    self.to_a.sort.hash
  end
end
