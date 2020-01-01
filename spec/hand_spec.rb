# frozen_string_literal: true

require 'hand'
require 'card'
require 'deck'
require 'rspec'

# The logic of calculating pair, three-of-a-kind, two-pair, etc. goes here.
# Logic of which hand beats which would go here.

describe 'Hand' do
  let(:ace_spades) { Card.new(1, 'Spades') }
  let(:ten_spades) { Card.new(10, 'Spades') }
  let(:jack_spades) { Card.new(11, 'Spades') }
  let(:queen_spades) { Card.new(12, 'Spades') }
  let(:king_spades) { Card.new(13, 'Spades') }

  let(:ace_hearts) { Card.new(1, 'Hearts') }

  let(:two_clubs) { Card.new(2, 'Clubs') }
  let(:three_clubs) { Card.new(3, 'Clubs') }
  let(:nine_spades) { Card.new(9, 'Spades') }
  let(:nine_diamonds) { Card.new(9, 'Diamonds') }
  let(:nine_hearts) { Card.new(9, 'Hearts') }

  let(:three_nines) do
    [nine_spades, nine_diamonds, nine_hearts]
  end

  let(:two_nines) do
    [nine_spades, nine_diamonds]
  end

  let(:two_aces) do
    [ace_spades, ace_hearts]
  end

  let(:high_card) do
    [two_clubs, nine_diamonds, ten_spades, queen_spades, king_spades]
  end

  let(:pair) { two_aces + [two_clubs, nine_diamonds, ten_spades] }

  let(:two_pair) { (two_nines + two_aces) << ten_spades }

  let(:straight) do
    [king_spades, queen_spades, jack_spades, ten_spades, nine_diamonds]
  end

  let(:flush) do
    [ace_spades, queen_spades, jack_spades, ten_spades, nine_spades]
  end

  let(:straight_flush) do
    [king_spades, queen_spades, jack_spades, ten_spades, nine_spades]
  end

  let(:royal_flush) do
    [ace_spades, king_spades, queen_spades, jack_spades, ten_spades]
  end

  let(:hands) do
    [royal_flush, straight_flush, flush, straight,
     two_pair, pair, high_card].map do |cards|
      Hand.new(cards)
    end
  end

  let(:deck) { Deck.new }

  subject(:hand) { Hand.new(pair) }

  describe '::winner' do
    it 'picks royal flush' do
      royal_flush_hand = Hand.new(royal_flush)
      royal_flush_hand.value
      # poker_hands = hands.map { |cards| Hand.new(cards) }
      expect(Hand.winner(hands)).to eq(royal_flush_hand)
    end

    it 'picks pair above high card' do
      hand_pair = Hand.new(pair)
      hands = [pair, high_card].map { |cards| Hand.new(cards) }
      expect(Hand.winner(hands)).to eq(hand_pair)
    end
  end

  describe '#initialize' do
    it 'takes array of cards' do
      expect { Hand.new(royal_flush) }.not_to raise_error
      expect { Hand.new([{ 'key': 'value' }]) }.to raise_error ArgumentError
      expect(Hand.new(royal_flush).cards).to match_array(royal_flush)
      # expect(Hand.new(royal_flush).cards).to contain_exactly(royal_flush)
    end
  end

  describe '#value' do
    # why it's not possible?
    # let(:three_nines) do [
    # nine_spades,
    #   Card.new(9, 'Hearts'),
    #   Card.new(9, 'Diamonds'),
    # ]

    it 'calculates value of royal flush' do
      expect(Hand.new(royal_flush).value).to eq 1000
      expect(Hand.new(straight_flush).value).not_to eq 1000
    end

    # straight flush
    #  five cards of sequential rank, all of the same suit,

    it 'calculates value of straight flush' do
      not_straight = [ace_spades, queen_spades, jack_spades, ten_spades, nine_spades]
      expect(Hand.new(straight_flush).value).to eq 913
      expect(Hand.new(not_straight).value).to be < 900
      expect(Hand.new(flush).value).to be < 900
    end

    # should test other combinations like straight flush is not scored like four of a kind?
    it 'calculates value of four of a kind' do
      four_of_kind = [nine_spades,
                      Card.new(9, 'Hearts'),
                      Card.new(9, 'Diamonds'),
                      Card.new(9, 'Clubs'),
                      Card.new(2, 'Clubs')]
      # debugger
      four_of_kind_value = Hand.new(four_of_kind).value
      # ?!
      # expect(Hand.new(four_of_kind).value).to be < 900 & to be > 800
      expect(four_of_kind_value).to be < 900
      expect(four_of_kind_value).to be > 800
    end

    it 'calculates value of full house' do
      full_house = three_nines + two_aces
      expect(Hand.new(full_house).value).to be < 800
      expect(Hand.new(full_house).value).to be > 700
    end

    it 'calculates value of flush' do
      expect(Hand.new(flush).value).to be > 600
      expect(Hand.new(flush).value).to be < 700
    end

    it 'calculates value of straight' do
      expect(Hand.new(straight).value).to be > 500
      expect(Hand.new(straight).value).to be < 600
    end

    it 'calculates value of three-of-a-kind' do
      three_nines.push(ace_spades, ten_spades)
      expect(Hand.new(three_nines).value).to be < 500
      expect(Hand.new(three_nines).value).to be > 400
    end

    it 'calculates value of two pair' do
      expect(Hand.new(two_pair).value).to be < 400
      expect(Hand.new(two_pair).value).to be > 300
    end

    it 'calculates value of pair' do
      expect(Hand.new(pair).value).to be < 300
      expect(Hand.new(pair).value).to be > 200
    end

    it 'calculates value of high card' do
      expect(Hand.new(high_card).value).to be < 200
      expect(Hand.new(high_card).value).to be > 0
    end
  end

  describe '#trade_cards' do
    it 'raises an error unless is given an array of numbers' do
      expect { Hand.new(pair).trade_cards }.to raise_error ArgumentError
      # is_a Array
      expect { hand.trade_cards(12, [queen_spades]) }.to raise_error 'Expected array of ints'
      expect { hand.trade_cards(%w[1 2], [queen_spades]) }.to raise_error 'Expected array of ints'
      expect { hand.trade_cards([1], [queen_spades]) }.not_to raise_error
      expect { hand.trade_cards([1, 2], [queen_spades, two_clubs]) }.not_to raise_error
    end

    # let(:traded_cards){ hand.cards[(0..1)] }
    let(:new_cards) { [three_clubs, queen_spades] }
    let(:traded_hand) { hand.trade_cards([1, 2], new_cards) }

    # traded_card = hand.cards[0]
    it 'discards specified cards' do
      # why it's necessary here? To initialize some var?
      # debugger
      hand = Hand.new(royal_flush)

      traded_cards = hand.cards[(0..1)]
      expect(traded_cards).to eq(hand.cards[(0..1)])
      expect(traded_cards).to eq([ace_spades, ten_spades])

      # debugger
      hand.trade_cards([1, 2], [two_clubs, nine_hearts])

      # debugger
      expect(hand.cards).not_to include(ace_spades, ten_spades)
    end

    it 'takes specified cards' do
      expect(traded_hand.count).to eq(5)
      expect(traded_hand).to include(*new_cards)
    end

    it 'raises an error if trade does not result in five cards' do
      expect { hand.trade_cards([1, 2], [two_clubs]) }.to raise_error 'After trade the hand must have 5 cards'
    end

    it 'raises an error if trade tries to discard cards out of range' do
      expect { hand.trade_cards([0], [two_clubs]) }.to raise_error 'Traded cards must be within range 1-5'
      expect { hand.trade_cards([-1], [two_clubs]) }.to raise_error 'Traded cards must be within range 1-5'
    end
  end
end
