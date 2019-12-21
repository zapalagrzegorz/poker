# frozen_string_literal: true

require 'hand'
require 'card'

# The logic of calculating pair, three-of-a-kind, two-pair, etc. goes here.
# Logic of which hand beats which would go here.

describe 'Hand' do
  # describe '#initialize'

  describe '#value' do
    let(:ace_spades) { Card.new(1, 'Spades') }
    let(:ace_hearts) { Card.new(1, 'Hearts') }

    let(:two_clubs) { Card.new(2, 'Clubs') }
    let(:nine_spades) { Card.new(9, 'Spades') }
    let(:nine_diamonds) { Card.new(9, 'Diamonds') }
    let(:nine_hearts) { Card.new(9, 'Hearts') }

    let(:ten_spades) { Card.new(10, 'Spades') }
    let(:jack_spades) { Card.new(11, 'Spades') }
    let(:queen_spades) { Card.new(12, 'Spades') }
    let(:king_spades) { Card.new(13, 'Spades') }

    let(:royal_flush) do
      [ace_spades, king_spades, queen_spades, jack_spades, ten_spades]
    end

    let(:straight_flush) do
      [king_spades, queen_spades, jack_spades, ten_spades, nine_spades]
    end

    let(:flush) do
      [ace_spades, queen_spades, jack_spades, ten_spades, nine_spades]
    end

    let(:straight) do
      [king_spades, queen_spades, jack_spades, ten_spades, nine_diamonds]
    end

    let(:three_nines) do
      [nine_spades, nine_diamonds, nine_hearts]
    end

    let(:two_nines) do
      [nine_spades, nine_diamonds]
    end

    let(:two_aces) do
      [ace_spades, ace_hearts]
    end

    let(:two_pair) { (two_nines + two_aces) << ten_spades }

    let(:pair) { two_aces + [two_clubs, nine_diamonds, ten_spades]}

    let(:high_card) do
      [two_clubs, nine_diamonds, ten_spades, queen_spades, king_spades]
    end
    # high_card[]

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
                      Card.new(9, 'Clubs')]
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
end
