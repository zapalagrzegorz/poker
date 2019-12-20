# frozen_string_literal: true

require 'rspec'
require 'deck'

describe Deck do
  subject(:deck) { Deck.new }

  let(:all_cards) { Deck.cards }

  describe '#initialize' do
    it 'starts with 52 Cards' do
      expect(all_cards.size).to eq(52)
    end

    it 'has 13 Cards of each color' do
      spade_cards = all_cards.select { |card| card.color == 'Spades' }
      hearts_cards = all_cards.select { |card| card.color == 'Hearts' }
      diamonds_cards = all_cards.select { |card| card.color == 'Diamonds' }
      clubs_cards = all_cards.select { |card| card.color == 'Clubs' }

      expect(spade_cards.size).to eq(13)
      expect(hearts_cards.size).to eq(13)
      expect(diamonds_cards.size).to eq(13)
      expect(clubs_cards.size).to eq(13)
    end

    #     it "returns all cards without duplicates" do
    #   expect(
    #     all_cards.map { |card| [card.suit, card.value] }.uniq.count
    #   ).to eq(all_cards.count)
    # end

    it 'is shuffled' do
      # card_props = {}
      first_card_new = Deck.new.cards.first
      first_card_old = deck.cards.first

      expect(first_card_old).to eq(first_card_new)
      # card_props[:color] = deck.cards.first.color
      # card_props[:value] =  deck.cards.first.value
      shuffled_deck = deck.cards.shuffle

      expect(shuffled_deck.first).not_to eq(first_card_new)
    end
  end

  # aby testować hidden props, jest metoda statyczna
  # it 'should not expose its cards' do
  # expect(deck).not_to respond_to(:cards)
  # end
  context 'when try to peek cards directly ' do
    it 'is not allowed' do
      expect(deck).not_to respond_to(:cards)
    end
  end


  # take
  describe '#take' do
    it 'takes cards from the top' do
      expect(deck.take(1)).to be(Cards)
    end
    it 'removes cards from the deck'

    it 'doesn\'t allow to take more cards than in the deck'
  end
  # dodawania i odejmowanie z talii
  #   describe '#add_player' do
  #   let(:player) { double('player', add_card: nil) }

  #   it 'binds card to player' do
  #     expect(player).to receive(:add_card).with(card)

  #     card.add_player(player)
  #   end

  #   it 'changes card to unavailable' do
  #     expect { card.add_player(player) }
  #       .to change { card.avail }.from(true).to(false)
  #   end
  # end
end
