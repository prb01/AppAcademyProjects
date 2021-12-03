class Array
  def my_uniq
    new_arr = []
    self.each { |el| new_arr << el unless new_arr.include?(el) }
    new_arr
  end

  
end