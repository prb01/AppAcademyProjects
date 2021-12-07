require 'rspec'
require 'game'

describe Game do
  let(:game) { Game.new(("A".."D").to_a, 100, 5) }

  describe '#initialize' do
    it 'takes names array as an input to create players' do
      expect(game.players.length).to eq(4)
    end
  end
end