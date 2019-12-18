# frozen_string_literal: true

require 'rspec'
require 'card'

describe Card do
  subject(:card) { Card.new(1, 'Spades') }

  describe '#initialize' do
    context 'with ace of spades' do
      let(:ace_of_spades) { Card.new(1, 'Spades') }

      it 'sets up initial @value, @color, @symbol and @avail' do
        expect(ace_of_spades.value).to eq(1)
        expect(ace_of_spades.color).to eq('Spades')
        expect(ace_of_spades.symbol).to eq('🂡')
        expect(ace_of_spades.avail).to eq(true)
      end
    end

    context 'with queen_of_hearts' do
      let(:queen_of_hearts) { Card.new(13, 'Hearts') }

      it 'sets up initial @value, @color, @symbol and @avail' do
        expect(queen_of_hearts.value).to eq(13)
        expect(queen_of_hearts.color).to eq('Hearts')
        expect(queen_of_hearts.symbol).to eq('🂽')
      end
    end
  end

  describe '#add_player' do
    let(:player) { double('player', add_card: nil) }

    it 'binds card to player' do
      expect(player).to receive(:add_card).with(card)

      card.add_player(player)
    end

    it 'changes card to unavailable' do
      expect { card.add_player(player) }
        .to change { card.avail }.from(true).to(false)
    end
  end
end
