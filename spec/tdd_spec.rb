require 'rspec'
require 'tdd'

describe Array do
  describe '#my_uniq' do
    let(:arr) { [1, 2, 1, 3, 3] }
    let(:arr2) { [3, 3, 1, 2] }

    it 'returns unique values' do 
      expect(arr.my_uniq).to eq([1, 2, 3])
    end

    it 'returns unique values in order of original array' do
      expect(arr2.my_uniq).to eq([3, 1, 2])
    end
  end

  describe '#two_sum' do
    let(:arr) { [-1, 0, 2, -2, 1] }
    let(:arr2) { [0, -5, -3, 1, -1, 5, 3] }

    it 'returns positions of values that sum to zero' do
      expect(arr.two_sum).to eq([[0, 4], [2, 3]])
    end

    it 'returns positions in numeric order' do
      expect(arr2.two_sum).to eq([[1, 5], [2, 6], [3, 4]])
    end
  end
end