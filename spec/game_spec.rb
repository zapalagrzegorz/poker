# frozen_string_literal: true

require 'rspec'
require 'game'
require 'player'
require 'byebug'

describe 'Game' do
  subject('game') { Game.new }

  let('game_with_players') do
    game.add_players(3, 100)
    game
  end

  describe '#initialize' do
    it 'should set up empty pot' do
      expect(game.pot).to be_zero
      expect(game.players).to be_empty
    end
  end

  # czemu deck jest odrębną jednostką skoro i tak wszystko inicjalizowane
  describe '#deck' do
    it 'should set up deck' do
      expect(game.deck).to be_a(Deck)
    end

    it 'should start with a full deck' do
      expect(game.deck.size).to eq(52)
    end
  end

  describe '#add_players' do
    it 'should create the specified number of players' do
      expect(game_with_players.players).to match_array([an_instance_of(Player),
                                                        an_instance_of(Player),
                                                        an_instance_of(Player)])
      expect(game_with_players.players.size).to eq(3)
    end
  end

  describe '#game_over' do
    it 'should return false when players still have money' do
      game.add_players(3, 100)
      expect(game.game_over).to eq(false)
    end

    it 'should return true when only one player have money' do
      game.add_players(2, 0)
      game.add_players(1, 10)

      expect(game.game_over).to eq(true)
    end
  end

  describe '#deal_cards' do
    it 'should give each player a full hand' do
      game_with_players.deal_cards
      # can i write expectation to check each element of array
      # has some prop?
      # it it right way?
      # https://github.com/rspec/rspec-expectations#yielding
      players_with_hands = game_with_players.players.none? do |player|
        player.hand.nil?
      end

      expect(players_with_hands).to(eq(true))
    end

    it 'should not give a player a hand if the player has no money' do
      game_with_players.add_players(1, 0)
      game_with_players.deal_cards
      players_with_hands = game_with_players.players.one? { |player| player.hand.nil? }

      expect(players_with_hands).to be(true)
    end
  end

  describe '#add_to_pot' do
    it 'should add the specified amount to the pot' do
      expect { game.add_to_pot(10) }.to change { game.pot }.by(10)
    end

    it 'should return the amount added' do
      expect(game.add_to_pot(10)).to eq(10)
    end
  end
end
