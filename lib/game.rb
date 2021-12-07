require_relative 'player'
require_relative 'deck'

class Game
  attr_reader :players, :pot, :ante, :cur_bet, :cur_player_idx, :dlr_idx

  def initialize(names, money, ante)
    @deck = Deck.new
    @pot = 0
    @ante = ante
    @cur_bet = 0
    @players = []
    names.each { |name| @players << Player.new(name, money) }
    @cur_player_idx = 1
    @dlr_idx = 0
  end

  def reset_round
    @deck = Deck.new
    @pot = 0
    @players.rotate!
    reset_player_hands
    @cur_player = players[0]
    @dealer = players[0]
    deck.shuffle!
  end

  def next_player
    @cur_player_idx = (@cur_player_idx + 1) % players.length
    next_player if players[cur_player_idx].folded
  end

  def deal
    5.times do 
      players.each do |player|
        player.take_card(deck.take_card)
      end
    end
  end

  def render_info
    system("clear")
    puts "Dealer:  #{players[dlr_idx].name}"
    puts "Current: #{players[cur_player_idx].name}"
    puts "Ante:    #{ante}"
    puts "Bet:     #{cur_bet}"
    puts "Pot:     #{pot}"
    puts
    puts "===Players info==="
    players.each do |player|
      puts "#{player.name}: #{player.pot}; cur_bet: #{player.cur_bet}; folded: #{player.folded}"
    end
    puts
  end

  def play
    until loser?
      reset_round
      deal
      take_ante
      round
      discard_cards
      round
      reward_winner(round_winners)
      render_info
      sleep(5)
    end
  end

  def round
    @cur_bet = 0
    reset_player_moves
    left_of_dealer
    until round_done?
      render_info
      player = players[cur_player_idx]
      player.display_hand
      move = player.get_move
      parse_move = player.parse_move(move, cur_bet)
      if player.raised
        remaining_players.each { |player| player.toggle_called if player.called }
      end
      @cur_bet = parse_move == 0 ? cur_bet : parse_move
      @pot += parse_move
      next_player
    end
  end

  def discard_cards
    left_of_dealer
    remaining_players.length.times do
      player = players[cur_player_idx]
      render_info
      player.display_hand
      discards = player.get_discards
      player.discard(discards, deck)
      until player.hand.length == 5
        player.take_card(deck.take_card)
      end
      render_info
      player.display_hand
      sleep(3)
      next_player
    end
  end

  def round_winners
    winners = [remaining_players[0]]
   
    remaining_players.each do |player|
      next if player == winners[0]

      case player.hand.higher_than?(winners[0].hand)
      when true
        winners = [player]
      when nil
        winners << player
      end
    end

    winners
  end

  def reward_winner(winners)
    reward = pot / winners.length

    winners.each do |player|
      player.change_pot(reward)
    end

    @pot = 0
  end

  def loser?
    players.any? do |player|
      player.pot <= ante
    end
  end

  private
  attr_reader :deck

  def take_ante
    players.each { |player| @pot += player.bet(ante) }
  end

  def reset_player_moves
    players.each { |player| player.reset_round }
  end

  def round_done?
    players.all? do |player|
      player.called && player.cur_bet == cur_bet ||
      player.raised ||
      player.folded
    end
  end

  def remaining_players
    players.select { |player| !player.folded }
  end

  def left_of_dealer
    cur_player_idx = dlr_idx + 1
  end

  def reset_player_hands
    players.each { |player| player.reset_match }
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new(["PRB","Caro","Boris","Denny"], 100, 5).play
end