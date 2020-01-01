# frozen_string_literal: true

require 'player'
require 'byebug'

describe 'Player' do
  subject(:player) { Player.new(100) }
  let(:hand) { double('hand', cards: 'cards') }

  describe '::buy_in' do
    it 'should create a player' do
      expect(Player.buy_in(100)).to be_a(Player)
    end

    it 'should set the players bankroll' do
      expect(Player.buy_in(100).bankroll).to eq(100)
    end
  end

  describe '#deal_in' do
    it 'should set the players hand' do
      player.deal_in(hand)
      expect(player.hand).to eq(hand)
    end
  end

  # one line or implicit subject
  # it { is_expected.to respond_with 422 }
  describe '#take_bet' do
    it 'should decrement player bankroll' do
      player.take_bet
      expect(player.bankroll).to eq(95)
    end

    it 'should decrement player bankroll by the raise amount' do
      player.take_bet(10)
      expect(player.bankroll).to eq(90)
    end

    # it 'should return the amount deducted' do
    #   expect(player.take_bet).to eq(5)
    #   expect(player.take_bet(10)).to eq(10)
    # end

    it 'should raise an error if the bet is more than the bankroll' do
      expect { player.take_bet(110) }.to raise_error 'not enough money'
    end
  end

  describe '#receive_winnings' do
    it 'should increment the players bankroll by the amount won' do
      expect { player.receive_winnings(25) }.to change { player.bankroll }.by(25)
      # change
    end
  end

  describe '#return_cards' do
    let(:cards) { double('cards') }
    it 'should return the players cards' do
      player.deal_in(hand)
      expect(player.return_cards).to eq('cards')
    end

    it 'should set the players hand to nil' do
      player.deal_in(hand)
      # player.return_cards
      expect { player.return_cards }.to change { player.hand }.from(hand).to(nil)
    end
  end

  describe '#fold' do
    it 'should set folded? to true' do
      expect { player.fold }.to change { player.folded? }.to(true)
    end
  end

  describe '#unfold' do
    it 'should set folded? to false' do
      player.fold
      expect { player.unfold }.to change { player.folded? }.to(false)
    end
  end

  describe '#folded?' do
    # let(:player) { Player.new(1000) }
    it 'should return true if player is folded' do
      player.fold
      expect(player.folded?).to eq(true)
    end

    it 'should return false otherwise' do
      player.fold
      player.unfold
      expect(player.folded?).to eq(false)
    end
  end
end
