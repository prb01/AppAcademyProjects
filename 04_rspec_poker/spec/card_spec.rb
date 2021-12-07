require 'rspec'
require 'card'

describe Card do
  describe '#initialize' do
    let(:card) { Card.new("spade", 10)}
    let(:face_card) { Card.new("spade", 12)}
    let(:bad_symbol) { Card.new("bogus", 10) }
    let(:bad_value) { Card.new("spade", 20) }

    it 'takes suit as an attribute' do
      expect(card.suit).to eq("spade")
    end

    it 'takes value as an attribute' do
      expect(card.value).to eq(10)
    end

    it 'sets face to value if below 10' do
      expect(card.face).to eq(card.value)
    end

    it 'sets face to face card name if above 10' do
      expect(face_card.face).to eq("Q")
    end

    it 'sets color based on suit' do
      expect(card.color).to eq(:black)
    end

    it 'sets symbol based on suit' do
      expect(card.symbol).to eq("♠")
    end

    it 'raises error if symbol not recognized' do
      expect{ bad_symbol }.to raise_error(ArgumentError)
    end

    it 'raises error if value is incorrect' do
      expect { bad_value }.to raise_error(ArgumentError)
    end
  end
end
