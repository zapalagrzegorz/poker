# frozen_string_literal: true

require 'byebug'

UNICODE_COLORS_MAP = {
  "Spades": 'A',
  "Hearts": 'B',
  "Diamonds": 'C',
  "Clubs": 'D'
}.freeze

class Card
  attr_reader :value, :color, :symbol, :avail

  include Comparable

  def initialize(value, color)
    @value = value
    @color = color
    @symbol = build_emoji
    @avail = true
  end

  def add_player(player)
    player.add_card(self)
    unavail
  end

  def ==(other)
    @value == other.value && @color == other.color
  end

  def to_s
    @symbol
  end

  def <=>(other)
    @value <=> other.value
  end

  #   if value != other_card.value
  #   Card.values.index(value) <=> Card.values.index(other_card.value)
  # elsif suit != other_card.suit
  #   Card.suits.index(suit) <=> Card.suits.index(other_card.suit)
  # end

  private

  # wartości unicode'owe uwzględniają również kartę Knight'a, którego zazwyczaj nie ma
  # w talii. Dostał on numer 12 - między Waletem i Damą. Stąd wartości unikodowe
  # są od 1..11 i 13..14 , stąd tutaj korekta, aby zachować ciągłość.

  def build_emoji
    unicode_value = value < 12 ? value : value + 1
    color = UNICODE_COLORS_MAP[@color.to_sym]
    unicode_code_point = "0x1F0#{color}#{unicode_value.to_s(16)}"
    [unicode_code_point.hex].pack('U*')
  end

  def unavail
    @avail = false
  end
end
