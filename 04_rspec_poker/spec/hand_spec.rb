require 'rspec'
require 'hand'

describe Hand do
let(:hand) { Hand.new }
let(:card) { double(Card, :value => 2, :suit => "club") }
let(:card2) { double(Card, :value => 3, :suit => "club") }
let(:card3) { double(Card, :value => 4, :suit => "club") }
let(:card4) { double(Card, :value => 5, :suit => "club") }
let(:card5) { double(Card, :value => 6, :suit => "club") }
let(:card6) { double(Card, :value => 7, :suit => "club") }
let(:deck) { double(Deck) }
let(:random_suit) { ["club","spade","diamond","heart"].sample }
let(:royal_hand) {
  hand = Hand.new
  (10..14).each do |i|
    hand.add(double(Card, :value => i, :suit => "club"))
  end
  hand
}
let(:worst_hand) {
  hand = Hand.new
  [2, 5, 7, 8, 9].each do |i|
    hand.add(double(Card, :value => i, :suit => ["club","spade","diamond","heart"].sample))
  end
  hand
}
let(:worst_hand2) {
  hand = Hand.new
  [2, 4, 6, 7, 8].each do |i|
    hand.add(double(Card, :value => i, :suit => ["club","spade","diamond","heart"].sample))
  end
  hand
}
let(:straight) {
  hand = Hand.new
  (5..9).each do |i|
    hand.add(double(Card, :value => i, :suit => ["club","spade","diamond","heart"].sample))
  end
  hand
}
let(:flush) {
  hand = Hand.new
  [2, 5, 7, 8, 9].each do |i|
    hand.add(double(Card, :value => i, :suit => random_suit))
  end
  hand
}
let(:one_pair) {
  hand = Hand.new
  [2, 7, 7, 8, 9].each do |i|
    hand.add(double(Card, :value => i, :suit => ["club","spade","diamond","heart"].sample))
  end
  hand
}
let(:full_house) {
  hand = Hand.new
  [8, 8, 2, 2, 2].each do |i|
    hand.add(double(Card, :value => i, :suit => ["club","spade","diamond","heart"].sample))
  end
  hand
}
let(:full_house2) {
  hand = Hand.new
  [7, 7, 2, 2, 2].each do |i|
    hand.add(double(Card, :value => i, :suit => ["club","spade","diamond","heart"].sample))
  end
  hand
}

  describe '#initialize' do
    it 'initializes an empty array for hand' do
      expect(hand.hand).to be_empty
    end
  end

  describe '#length' do
    it 'counts the amount of cards in hand' do
      expect(hand.length).to eq(hand.hand.length)
    end
  end
  
  describe '#add' do
    it 'adds card to hand' do
      expect(hand.length).to eq(0)
      hand.add(card)
      expect(hand.length).to eq(1)
    end

    it 'only adds card if player has less than 5' do
      hand.add(card)
      hand.add(card2)
      hand.add(card3)
      hand.add(card4)
      hand.add(card5)
      expect { hand.add(card6) }.to raise_error('You have 5 cards already')
    end
  end

  describe '#discard' do
    before(:each) { 
      hand.add(card)
      hand.add(card2)
      hand.add(card3)
      allow(deck).to receive(:add_card)
    }

    it 'removes card from hand' do
      expect(hand.length).to eq(3)
      hand.discard(card, deck)
      expect(hand.length).to eq(2)
    end

    it 'only removes card if player has more than 2 cards' do
      hand.discard(card, deck)
      expect { hand.discard(card, deck) }.to raise_error('You can only discard up to 3 cards')
    end
  end

  describe '#rank' do
    it 'gives royal flush best rank' do
      expect(royal_hand.rank).to eq(1)
    end

    it 'gives high card worst rank' do
      expect(worst_hand.rank).to eq(10)
    end
  end

  describe '#maxes' do
    it 'returns the max card value for flush or straight' do
      expect(flush.maxes).to eq([9])
    end

    it 'returns the max card value for a pair' do
      expect(one_pair.maxes).to eq([7])
    end

    it 'returns all max card values for each unique pair' do
      expect(full_house.maxes).to include(8, 2)
    end

    it 'returns max for longest of a kind first' do
      expect(full_house.maxes[0]).to eq(2)
    end
  end

  describe '#higer_than?' do
    context 'returns true when' do
      it 'hand has higher rank than other hand' do
        expect(royal_hand.higher_than?(full_house)).to eq true
      end

      it 'hand has same rank but higher max (1 or no pair)' do
        expect(worst_hand.higher_than?(worst_hand2)).to eq true
      end

      it 'hand has same rank but higher max (2 of a kinds)' do
        expect(full_house.higher_than?(full_house2)).to eq true
      end
    end

    context 'returns false when' do
      it 'hand has lower rank than other hand' do
        expect(flush.higher_than?(full_house)).to eq false
      end

      it 'hand has same rank but lower max (1 or no pair)' do
        expect(worst_hand2.higher_than?(worst_hand)).to eq false
      end

      it 'hand has same rank but lower max (2 of a kinds)' do
        expect(full_house2.higher_than?(full_house)).to eq false
      end
    end

    context 'return nil when' do
      it 'hand has same rank and same maxes' do
        expect(full_house.higher_than?(full_house)).to eq nil
      end
    end
  end
end