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
end