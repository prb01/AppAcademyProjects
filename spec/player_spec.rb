require 'rspec'
require 'player'

describe Player do
  let(:player) { Player.new("PRB", 100) }
  let(:hand) { double(Hand) }

  describe '#initialize' do
    it 'takes name as an input' do
      expect(player.name).to eq("PRB")
    end

    it 'takes pot as an input' do
      expect(player.pot).to eq(100)
    end

    it 'initializes hand as hand class' do
      expect(player.hand).to be_a(Hand)
    end
  end

  describe '#change_pot' do
    context 'when input is positive' do
      it 'adds amount to player pot' do
        expect(player.pot).to eq(100)
        player.change_pot(50)
        expect(player.pot).to eq(150)
      end
    end

    context 'when input is negative' do
      it 'subtracts amount from player pot' do
        expect(player.pot).to eq(100)
        player.change_pot(-50)
        expect(player.pot).to eq(50)
      end

      it 'raises error if amount is more than player pot' do
        expect{ player.change_pot(-150) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#discard' do
  end
end