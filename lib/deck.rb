# frozen_string_literal: true

require_relative 'card.rb'
require_relative 'hand.rb'
require 'byebug'

COLORS = %w[Spades Hearts Diamonds Clubs].freeze
# omiting 12 of Knight Card
# all_cards

CARD_VALUES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13].freeze
# 1 - Ace
# 14 - King,
# 13 - Q
# 11 - Jack
# 10 - 10
# 9 - 9 etc.

class Deck
  def self.cards
    cards = []
    CARD_VALUES.each do |value|
      COLORS.each do |color|
        cards << Card.new(value, color)
      end
    end
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

  def deal_hand
    Hand.new(take_cards(5))
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
