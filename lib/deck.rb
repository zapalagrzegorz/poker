# frozen_string_literal: true

require_relative 'card.rb'
require 'byebug'

COLORS = %w[Spades Hearts Diamonds Clubs].freeze
# omiting 12 of Knight Card
# all_cards
UNICODE_CARD_VALUES = ((1..11).to_a + (13..14).to_a).freeze
# ALL_UNICODE_CARD_VALUES.delete_at(12)

# .freeze
# korekta 12 -> 13
# 13 -> 14

class Deck
  def self.cards
    cards = []
    UNICODE_CARD_VALUES.each do |value|
      COLORS.each do |color|
        cards << Card.new(value, color)
      end
    end
    # cards.shuffle
    cards
  end

  def initialize
    @cards = Deck.cards
  end

  def size
    @cards.size
  end

  def take_cards(number)
    raise 'Insufficent number of cards' if number > @cards.size

    @cards.pop(number)
  end

  def return(cards)
    if cards.is_a?(Array)
      raise 'Deck#return accepts only Cards' unless cards.all? { |card| card.is_a?(Card) }
    else
      raise 'Deck#return accepts only Cards' unless cards.is_a?(Card)
    end
    @cards.unshift(*cards)
  end

  def shuffle
    @cards.shuffle!
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

class CardsNotLeftError < StandardError
  def message
    puts 'Insufficent number of cards'
  end
end
