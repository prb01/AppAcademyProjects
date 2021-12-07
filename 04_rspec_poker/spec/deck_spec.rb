require 'rspec'
require 'deck'

describe Deck do
  let(:deck) { Deck.new }
  let(:cards) { 
    cards = [] 
    deck.cards.each { |card| cards << card.value }
    cards }
  let(:shuffled_deck) { Deck.new }
  let(:shuffled_cards) { 
    cards = [] 
    shuffled_deck.cards.each { |card| cards << card.value }
    cards }

  describe '#initialize' do
    it 'creates an array with 52 Cards' do
      expect(deck.cards.count).to eq(52)
    end

    it 'creates Card instances for each of the 52' do
      expect(deck.cards).to all(be_a(Card))
    end
  end

  describe '#shuffle!' do
    it 'before shuffling' do
      expect(cards).to eq(shuffled_cards)
    end

    it 'shuffles the deck' do
      shuffled_deck.shuffle!
      expect(cards).not_to eq(shuffled_cards)
    end
  end

  describe '#take_card' do
    it 'returns the taken card' do
      last_card = deck.cards[-1]
      expect(deck.take_card).to eq(last_card)
    end

    it 'reduces deck by card taken' do
      deck.take_card
      expect(deck.cards.count).to eq(51)
    end
  end

  describe '#add_card' do
    let(:taken_card) { deck.take_card }
    let(:card) { double(Card, :value => 15, :suit => "club") }
    
    it 'adds card to bottom of pile' do
      deck.add_card(taken_card)
      expect(deck.cards[0]).to eq(taken_card)
    end

    it 'adds to total deck count' do
      allow(card).to receive(:is_a?).with(Card) { true }
      deck.take_card
      expect(deck.cards.count).to eq(51)
      deck.add_card(card)
      expect(deck.cards.count).to eq(52)
    end

    it 'only allows card of class Card to be added' do
      expect{ deck.add_card("card") }.to raise_error(ArgumentError)
    end
  end
end