# frozen_string_literal: true

# Each player has a hand, plus a pot
# Player has methods to ask the user:
# Which cards they wish to discard
# Whether they wish to fold, see, or raise.
class Player
  attr_reader :bankroll, :hand, :current_bet

  include Comparable

  def self.buy_in(bankroll)
    Player.new(bankroll)
  end

  def initialize(bankroll)
    @name = nil
    @hand = nil
    @bankroll = bankroll
    @folded = false
    @current_bet = 0
  end

  def cards_to_discard
    puts 'Which cards do you want to discard? Enter numbers like "1,3,5"
      Enter "nothing", not to discard any card.'
    print '>'
    user_input = STDIN.gets.chomp
    parse_idxs_to_discard(user_input)
    # @hand.trade_cards
  rescue StandardError => e
    puts e.message
    puts 'Please try again.'
    retry
  end

  def respond_bet
    print '(c)all, (b)et, or (f)old? > '
    response = gets.chomp.downcase[0]
    case response
    when 'c' then :call
    when 'b' then :bet
    when 'f' then :fold
    else
      puts 'must be (c)all, (b)et, or (f)old'
      respond_bet
    end
  end

  # def turn_decision
  #  return_cardswhen 'f'
  #     fold
  #   end
  # end

  # isn't it just an alias for hand setter?
  def deal_in(hand)
    @hand = hand
  end

  # def take_bet(bet = 5)cards
  #   bet
  # end

  def receive_winnings(pot)
    @bankroll += pot
  end

  def return_cards
    return_cards = @hand.cards
    @hand = nil

    return_cards
  end

  def folded?
    @folded ? true : false
  end

  def fold
    @folded = true
  end

  def unfold
    @folded = false
  end

  def get_bet
    print "Bet (bankroll: $#{bankroll}) > "
    bet = gets.chomp.to_i
    raise 'not enough money' unless bet <= bankroll

    bet
  end

  def take_bet(total_bet = 5)
    # ?
    amount = total_bet - @current_bet
    raise 'not enough money' unless amount <= bankroll

    @current_bet = total_bet
    @bankroll -= amount
    amount
  end

  def get_cards_to_trade
    print "Cards to trade? (ex. '1, 4, 5'). Press nothing not to change cards  > "
    card_indices = gets.chomp.split(', ').map(&:to_i)
    raise 'cannot trade more than three cards' unless card_indices.count <= 3

    puts
    card_indices
    # card_indices.map { |i| hand.cards[i - 1] }
  end

  def show_hands
    puts 'HANDS'
    players.each do |player|
      next if player.folded?

      puts player.hand.to_s
    end
  end

  def <=>(other_player)
    hand.value <=> other_player.hand.value
  end

  def reset_current_bet
    @current_bet = 0
  end

  def trade_cards(old_cards, new_cards)
    hand.trade_cards(old_cards, new_cards)
  end

  private

  def parse_idxs_to_discard(user_input)
    user_input.split(',').map { |_num| Integer(i) }
  end

  def user_turn_decision
    puts 'Press "f" to fold, "b" to bet, "c" to check or "r" to raise.'
    print '>'
    user_input = STDIN.gets.chomp
    user_decision = parse_turn_decision(user_input)
  # if user_input.length.zero?
  rescue StandardError => e
    puts e
    retry
  end

  def parse_turn_decision
    raise 'Please give decision' if user_input.length.zero?

    user_decision = user_input[0]
    raise 'Unknown decision' unless user_decision.include?('b', 'c', 'f', 'r')

    user_decision
  end
end
