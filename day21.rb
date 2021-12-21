def deterministic_roll!
  @last_roll  ||= 0
  @last_roll  = (@last_roll + 1) % 10
  {@last_roll => 1}
end

DIRAC_DISTRIBUTION = Hash.new(0).tap do |h|
  3.times do |a|
    3.times do |b|
      3.times do |c|
        h[a + b + c + 3] += 1
      end
    end
  end
end

def roll!
  @roll_count ||= 0
  @roll_count += 1
  # deterministic_roll!
  {1=>1, 2=>1, 3=>1} #DIRAC_DISTRIBUTION
end

GameState = Struct.new(:positions, :scores, :games_in_state)

def play(positions, target = 1000)
  wins = [0] * positions.size
  turn = 0
  states = [GameState.new(positions, [0] * positions.size, 1)]
  winning_states = []

  idx = 0
  loop do
    3.times do
      # games_from_roll = 0
      new_states_for_turn = []
      roll!.each do |(roll, count)|
        # pp "Roll #{roll} Count #{count}"
        states.each do |game_state|
          new_position = game_state.positions[turn] + roll
          new_position = new_position % 10 if new_position > 10
          new_positions = game_state.positions.dup
          new_positions[turn] = new_position
          new_states_for_turn << GameState.new(
            new_positions,
            game_state.scores.dup,
            game_state.games_in_state * count
          )
        end


      end
      states_by_position_and_score = new_states_for_turn.group_by {|s| [s.positions, s.scores]}
      states = states_by_position_and_score.keys.map do |k|
        games = states_by_position_and_score[k].map(&:games_in_state).sum
        GameState.new(k[0], k[1], games)
      end
      # pp "new states #{states}"
      # states = new_states_for_turn
    end

    states.each do |state|
      # pp "state.scores[turn] #{state.scores[turn]} += state.positions[turn] #{state.scores[turn] + state.positions[turn]}"
      state.scores[turn] += state.positions[turn]
      if state.scores[turn] >= target
        wins[turn] += state.games_in_state
        state.games_in_state = 0
      end
    end
    active_states, done_states = states.partition {|state| state.games_in_state > 0}
    states = active_states
    winning_states += done_states
    # pp "winning_states #{winning_states}"
    # pp "States: #{states}"
    # pp wins.size
    break if states.empty?


    turn = (turn + 1) % positions.size
  end
  [wins, @roll_count]
end

data = <<~EOM
Player 1 starting position: 4
Player 2 starting position: 8
EOM
data = File.read('day21.txt')
result = play(data.lines.map{|l| l.split(': ').last.to_i}, 21)
pp result
# pp [result, @roll_count, result[2] * @roll_count]

