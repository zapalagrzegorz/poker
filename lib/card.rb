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

  # wartości unicode'owe uwzględniają również kartę Knight'a, którego zazwyczaj nie ma
  # w talii. Dostał on numer 12 - między Waletem i Damą, stąd tutaj korekta, aby
  # zachować ciągłość
  def initialize(value, color)
    @unicode_value = value

    @value = value < 11 ? value : value - 1
    @color = color
    @symbol = build_emoji
    @avail = true
  end

  def add_player(player)
    player.add_card(self)
    unavail
  end

  # def discard
  # status
  # end

  def ==(other)
    @value == other.value && @color == other.color
  end

  private

  def build_emoji
    color = UNICODE_COLORS_MAP[@color.to_sym]
    unicode_code_point = "0x1F0#{color}#{@unicode_value.to_s(16)}"
    [unicode_code_point.hex].pack('U*')
  end

  def unavail
    @avail = false
  end
end
