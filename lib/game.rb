# frozen_string_literal: true

require_relative 'deck'
require_relative 'player'

class Game
  attr_reader :pot, :deck, :players

  def initialize
    @pot = 0
    @deck = Deck.new
    @players = []
  end

  def add_players(players_num, bankroll)
    players_num.times { @players << Player.new(bankroll) }
    @players
  end

  def play
    play_round until game_over
    end_game
  end

  def play_round
    deck.shuffle
    # ?
    reset_players
    deal_cards
    take_bets
    trade_cards
    take_bets
    end_round
  end

  def reset_players
    @players.each(&:unfold)
  end

  def deal_cards
    @players.each do |player|
      next if player.bankroll.zero?

      player.deal_in(@deck.deal_hand)
    end
  end

  # def trade_cards; end

  def round_over?
    players.count { |player| !player.folded? } <= 1
  end

  def game_over
    @players.one? { |player| player.bankroll.positive? }
  end

  def add_to_pot(sum)
    @pot += sum if sum.positive?
  end

  def take_bets
    players.each(&:reset_current_bet)
    high_bet = 0
    no_raises = false
    most_recent_better = nil

    until no_raises
      no_raises = true
      players.each_with_index do |player, i|
        next if player.folded?
        break if most_recent_better == player || round_over?

        display_status(i, high_bet)

        begin
          response = player.respond_bet
          case response
          when :call
            add_to_pot(player.take_bet(high_bet))
          when :bet
            raise 'not enough money' unless player.bankroll >= high_bet

            no_raises = false
            most_recent_better = player
            bet = player.get_bet
            raise "bet must be at least $#{high_bet}" unless bet >= high_bet

            rs = player.take_bet(bet)
            high_bet = bet
            add_to_pot(rs)
          when :fold
            player.fold
          end
        rescue StandardError => e
          puts e.message.to_s
          retry
        end
      end
    end
  end

  def display_status(index, high_bet)
    puts
    puts "Pot: $#{@pot}"
    puts "High bet: $#{high_bet}"

    players.each_with_index do |player, i|
      puts "Player #{i + 1} has #{player.bankroll}"
    end

    puts
    puts "Current player: #{index + 1}"
    puts "Player #{index + 1} has bet: $#{players[index].current_bet}"
    puts "The bet is at $#{high_bet}"
    puts "Player #{index + 1}'s hand: #{players[index].hand}"
  end

  def trade_cards
    players.each_with_index do |player, i|
      next if player.folded?

      print "Player #{i + 1}, which cards do you want to trade: "
      puts player.hand
      begin
        cards_idxs = player.get_cards_to_trade
        # debugger
        next if cards_idxs.size.zero?

        debugger
        # card_indices.map { |i| hand.cards[i - 1] }
        cards = cards_idxs.map { |idx| player.hand.cards[idx - 1] }
        deck.return(cards)
        player.trade_cards(cards_idxs, deck.take_cards(cards.count))
      rescue StandardError => e
        puts e
        retry
      end
    end
  end

  def end_round
    show_hands
    puts
    puts 'WINNER'
    puts "#{winner.hand} wins $#{pot}"
    winner.receive_winnings(pot)
    @pot = 0
    return_cards
  end

  def winner
    @players.max
  end

  def end_game
    puts 'The game is over'
  end

  def show_hands
    puts 'HANDS'
    players.each do |player|
      next if player.folded?

      puts player.hand.to_s
    end
  end

  def return_cards
    players.each { |player| @deck.return(player.return_cards) }
  end
end

if $PROGRAM_NAME == __FILE__
  g = Game.new
  g.add_players(2, 100)
  g.play
end
