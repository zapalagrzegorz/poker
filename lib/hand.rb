# frozen_string_literal: true

require_relative 'card'
require_relative 'deck'
require 'byebug'

# Groups player cards, sets their value, and allow for changes (#trade_cards)
class Hand
  attr_reader :cards

  def self.winner(hands)
    raise ArgumentError unless hands.any? { |hand| hand.is_a? Hand }

    # debugger
    hands.inject do |highest_hand, hand|
      hand.value > highest_hand.value ? hand : highest_hand
    end
  end

  def initialize(cards)
    raise ArgumentError unless cards.any? { |card| card.is_a?(Card) }
    raise ArgumentError unless cards.count == 5

    @cards = cards.sort!
    @cards_values = @cards.map(&:value).sort
    @cards_colors = @cards.map(&:color)
    @color = @cards_colors[0]
    @value = 0
  end

  def value
    return @value if royal_flush

    return @value if straight_flush

    return @value if four_of_kind

    return @value if full_house

    return @value if flush

    return @value if straight

    return @value if three_of_kind

    return @value if two_pair

    return @value if pair

    high_card
  end

  def trade_cards(discarded_card_idxs, new_cards)
    unless discarded_card_idxs.is_a?(Array) && discarded_card_idxs.any? { |num| num.is_a?(Integer) }
      raise 'Expected array of ints'
    end

    raise 'After trade the hand must have 5 cards' unless discarded_card_idxs.count == new_cards.count

    unless discarded_card_idxs.all? { |idx| (1..5).cover?(idx) }
      raise 'Traded cards must be within range 1-5'
    end

    discarded_card_idxs.map! { |idx| idx - 1 }

    @cards = @cards.reject.with_index do |_card, idx|
      discarded_card_idxs.include?(idx)
    end

    @cards += new_cards
    @cards.sort!
  end

  def ==(other)
    value == other.value
  end

  def to_s
    @cards.join(' ')
  end

  private

  def royal_flush
    return nil unless @cards_values.sort == [1, 10, 11, 12, 13]

    return nil unless @cards_colors.all? { |card_color| card_color == @color }

    @value = 1000
  end

  def straight_flush
    # refactor z TDD ex
    @cards_values[0..3].each.with_index do |card_value, card_idx|
      return nil unless card_value + 1 == @cards_values[card_idx + 1]
    end

    return nil unless @cards_colors.all? { |card_color| card_color == @color }

    @value = 900 + @cards_values.max
  end

  def four_of_kind
    counter = Hash.new(0)
    @cards.each do |card|
      counter[card.value] += 1
    end

    return nil unless counter.values.max == 4

    @value = 800 + @cards_values[0]
  end

  def full_house
    counter = Hash.new(0)
    @cards.each do |card|
      counter[card.value] += 1
    end

    return nil unless counter.keys.size == 2

    @value = 700 + @cards_values.sum
  end

  def flush
    return nil unless @cards_colors.all? { |card_color| card_color == @color }

    @value = 600 + @cards_values.max
  end

  def straight
    @cards_values[0..3].each.with_index do |card_value, card_idx|
      return nil unless card_value + 1 == @cards_values[card_idx + 1]
    end

    @value = 500 + @cards_values.max
  end

  def three_of_kind
    counter = Hash.new(0)
    @cards.each do |card|
      counter[card.value] += 1
    end

    return nil unless counter.values.max == 3

    @value = 400 + @cards_values.sum
  end

  def two_pair
    counter = Hash.new(0)
    @cards.each do |card|
      counter[card.value] += 1
    end

    return nil unless counter.values.sort == [1, 2, 2]

    @value = 300 + @cards_values.sum
  end

  def pair
    counter = Hash.new(0)
    @cards.each do |card|
      counter[card.value] += 1
    end

    return nil unless counter.values.sort == [1, 1, 1, 2]

    @value = 200 + @cards_values.sum
  end

  def high_card
    @cards_values.max
  end
end
