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

  describe '#my_transpose' do
    let(:rows) { [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ] }
    let(:cols) { [
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8]
    ] }

    it 'transposes rows to cols in square array' do
      expect(rows.my_transpose).to eq(cols)
    end

    it 'transposes cols to rows in square array' do
      expect(cols.my_transpose).to eq(rows)
    end
  end

  describe '#stock_picker' do
    let(:stock_rising) { [0.1, 0.05, 0.2, 0.5, 0.99, 1.5, 2.5, 4, 3.8] }
    let(:stock_buys) { [5, 6, 3, 4, 3, 8, 5, 6, 7, 7] }
    let(:stock_sells) { [5, 6, 3, 4, 4, 8, 5, 6, 8, 8] }
    let(:stock_roller) { [10, 7, 5, 1, 6, 8, 4, 3, 1] }
    let(:stock_falling) { [10, 9, 8, 7, 6, 5, 4, 3, 2] }

    it 'outputs pair of days indicating lowest buy and highest sell' do
      expect(stock_rising.stock_picker).to eq([1, 7])
    end

    it 'if multiple lowest buy days at same price, picks first' do
      expect(stock_buys.stock_picker).to eq([2, 5])
    end

    it 'if multiple highest sell days at same price, picks first' do
      expect(stock_sells.stock_picker).to eq([2, 5])
    end

    it 'always picks a sell date after buying' do
      expect(stock_roller.stock_picker).to eq([3, 5])
    end

    it 'returns error if bought at highest price' do
      expect{ stock_falling.stock_picker}.to raise_error("Stock bought at highest price")
    end
  end
end

describe Board do
  subject(:board) { Board.new }

  describe '#initialize' do
    it 'takes @size of stacks as an input' do
      expect(Board.new(5).size).to eq(5)
    end

    it 'defaults to a size of 4 if not provided' do
      expect(board.size).to eq(4)
    end

    it 'creates a @board with 3 arrays' do
      expect(board.board.length).to eq(3)
    end

    it 'populates 1st array with discs in descending order depending on size' do
      expect(board.board[0]).to eq([4, 3, 2, 1])
    end
  end

  describe '#move_disc' do
    it 'moves top disc to another stack' do
      board.move_disc(0, 2)
      expect(board.board).to eq([[4, 3, 2], [], [1]])
    end

    it 'does not move disc if disc is smaller' do
      board.move_disc(0, 2)
      board.move_disc(0, 2)
      expect(board.board).to eq([[4, 3, 2], [], [1]])
    end

    it 'does not move disc if stack is out of range' do
      board.move_disc(0, 2)
      board.move_disc(0, 5)
      expect(board.board).to eq([[4, 3, 2], [], [1]])
    end
  end

  describe '#won?' do
    let(:small_board) { Board.new(3) }

    it 'return false if not won' do
      expect(small_board.won?).to eq false
    end

    it 'return true  if won' do
      small_board.move_disc(0, 2)
      small_board.move_disc(0, 1)
      small_board.move_disc(2, 1)
      small_board.move_disc(0, 2)
      small_board.move_disc(1, 0)
      small_board.move_disc(1, 2)
      small_board.move_disc(0, 2)
      expect(small_board.won?).to eq true
    end
  end
end

describe Player do
  let(:board) { double("board") }
  subject(:player) { Player.new("Patrick", board) }

  describe '#initialize' do
    it 'takes name as an input' do
      expect(player.name).to eq("Patrick")
    end

    it 'takes board as an input' do
      expect(player.board).to eq board
    end
  end
end

describe Hanoi do
  subject(:game) { Hanoi.new("Patrick") }

  describe '#initialize' do
    it 'takes name as an input' do
      expect(game).not_to raise_error(ArgumentError)
    end

    it 'creates Player instance' do
      expect(game.player.class).to eq("Player")
    end

    it 'creates Board instance' do
      expect(game.board.class).to eq("Board")
    end
  end
end