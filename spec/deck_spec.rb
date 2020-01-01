# frozen_string_literal: true

require 'rspec'
require 'deck'
require 'hand'
require 'card.rb'

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
  end

  # aby testować hidden props, jest metoda statyczna Deck.cards
  # stawianie tu mocka - oznaczałoby, że w teście napisałbym własną implementację
  # budującą talię
  # it 'should not expose its cards' do
  # expect(deck).not_to respond_to(:cards)
  # end
  it 'should not expose its cards' do
    expect(deck).not_to respond_to(:cards)
  end

  it 'made deck of class Deck' do
    expect(deck).to be_a(Deck)
  end

  # take
  describe '#take' do
    let(:first_card) { Card.new(1, 'Spades') }
    last_card = Card.new(13, 'Clubs')

    it 'takes a card' do
      expect(deck.take_cards(1)[0]).to be_a(Card)
    end

    it 'takes cards from the top' do
      expect(deck.take_cards(1)).to eq([last_card])
    end

    it 'removes cards from the deck' do
      deck.take_cards(2)
      expect(deck.size).to eq(50)
    end

    it 'doesn\'t allow to take more cards than in the deck' do
      # expect { deck.take_cards(53) }.to raise_error CardsNotLeftError
      expect { deck.take_cards(53) }.to raise_error 'Insufficent number of cards'
    end
  end

  describe '#return' do
    let(:some_card) { Card.new(4, 'Spades') }
    let(:some_cards) { [some_card, Card.new(6, 'Hearts')] }

    it 'accepts cards' do
      expect { deck.return(some_card) }.not_to raise_error
      expect { deck.return('not_card') }.to raise_error 'Deck#return accepts only Cards'
    end

    it 'puts card to the deck' do
      # expect(deck.size).to eq(52)
      deck.take_cards(52)
      # expect(deck.size).to eq(1)
      deck.return(some_card)
      expect(deck.size).to eq(1)
    end

    it 'puts array of cards to the deck' do
      deck.take_cards(52)
      # expect { deck.return(some_cards) }.to change { deck.size }.by(2)
      expect { deck.return(some_cards) }.to change { deck.size }.from(0).to(2)
      expect(deck.size).to eq(2)
    end

    it 'puts cards to the bottom of deck' do
      deck.take_cards(51)
      deck.return(some_cards)
      expect(deck.take_cards(2)).not_to include(some_card)
    end
  end

  describe '#shuffle' do
    it 'makes cards in deck randomized' do
      # card_props = {}
      deck.take_cards(52)
      last_card = all_cards.last
      deck.return(all_cards)
      deck.shuffle
      expect(deck.take_cards(52).last).not_to eq(last_card)
      # first_card_old = all_cards.last

      # expect(first_card_old).to eq(deck.take_cards(1).first)
      # deck.shuffle

      # expect(deck.first).not_to eq(first_card_new)
    end
  end

  describe '#deal_hand' do
    let(:deal_hand) { deck.deal_hand }

    it 'should return a new hand' do
      # hand = deck.deal_hand
      expect(deal_hand).to be_a(Hand)
      expect(deal_hand.cards.count).to eq(5)
    end

    it 'should take cards from the deck' do
      deal_hand
      expect { deck.deal_hand }.to change { deck.size }.by(-5)

    end
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
