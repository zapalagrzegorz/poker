# frozen_string_literal: true

require_relative 'card.rb'
require 'byebug'

COLORS = %w[Spades Hearts Diamonds Clubs].freeze
# omiting 12 of Knight Card
VALUES = ((1..11).to_a + (13..14).to_a).freeze

class Deck
  def self.cards
    build_deck
  end

  def initialize
    @cards = build_deck
  end

  def size
    @cards.size
  end

  private

  def build_deck
    cards = []
    VALUES.each do |value|
      COLORS.each do |color|
        cards << Card.new(value, color)
      end
    end
    # cards.shuffle
    cards
  end
end
