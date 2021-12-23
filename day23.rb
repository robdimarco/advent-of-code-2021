data = <<~EOM
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
EOM

ENERGY_MAP = {'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000}
ROOMS = %w(A B C D)

World = Struct.new(:rooms, :hall) do
  def done?
    return false if hall.compact.size > 0
    rooms.each_with_index do |room, idx|
      l = ROOMS[idx]
      return false unless room == [l, l]
    end

    true
  end

  def deep_clone
    World.new(rooms.map{|r| r.dup}, hall.dup)
  end

  def next_moves
    return [] if done?
    rv = []
    hall.each_with_index do |l, i|
      next unless l
      eligible_room = l.hex - 'A'.hex
      next unless rooms[eligible_room][0].nil?
      next unless rooms[eligible_room][1].nil? || rooms[eligible_room][1] == l


      room_loc = (eligible_room + 1) *2

      range = [i, room_loc].sort
      slice = hall.slice(range[0], range[1] - range[0] + 1)
      next unless slice.compact.size == 1

      w = deep_clone
      w.hall[i] = nil
      energy_used = (i-room_loc).abs * ENERGY_MAP[l]

      if rooms[eligible_room][1].nil?
        w.rooms[eligible_room][1] = l
        energy_used += 2 * ENERGY_MAP[l]
      else
        w.rooms[eligible_room][0] = l
        energy_used += ENERGY_MAP[l]
      end
      rv.push([w, energy_used])
    end

    rooms.each_with_index do |room, i|
      l = nil
      energy_out = nil
      room_loc = nil

      if room[0]
        l = room[0]
        energy_out = ENERGY_MAP[l]
        room_loc = 0
      elsif room[1]
        l = room[1]
        energy_out = 2 * ENERGY_MAP[l]
        room_loc = 1
      end

      next unless l
      next if i == l.hex - 'A'.hex && room_loc == 1 # Do not move if in right room
      next if i == l.hex - 'A'.hex && room_loc == 0 && room[1] == l # Do not move if in right room

      valid_hall_spots = (0...hall.size).to_a.map do |h|
        next if hall[h]
        # Skip even positions as they are by rooms except for ends
        next if (h % 2) == 0 && h > 0 && h < (hall.size - 2)

        room_pos = (i+1) * 2
        range = [h, room_pos].sort
        slice = hall.slice(range[0], range[1] - range[0] + 1)
        slice.compact.size == 0 ? h : nil
      end.compact

      valid_hall_spots.each do |h|
        w = deep_clone
        w.hall[h] = l
        w.rooms[i][room_loc] = nil
        rv.push([w, energy_out + ((i + 1) * 2 - h).abs * ENERGY_MAP[l]])
      end
    end
    done_moves = rv.select {|l| l[0].done?}
    if done_moves.size > 0
      done_moves
    else
      rv
    end
  end

  def token
    rv = ''
    hall.each do |h|
      rv << (h || '.')
    end

    rooms.each do |r|
      rv << '|'
      r.each do |l|
        rv << (l || '.')
      end
    end

    rv
  end
end

def world_from_data(data)
  rv = World.new((0..3).reduce([]) {|acc| acc.push([nil, nil])}, [nil] * 11)
  lines = data.lines
  2.times do |i|
    row = lines[2 + i]
    row.scan(/[A-Z]/).each_with_index do |l, j|
      rv.rooms[j][i] = l
    end
  end

  rv
end

# w =
# l = w.rooms[0][0]
# w.hall[0] = l
# w.rooms[0][0] = nil
# pp w.next_moves

# l = w.rooms[0][1]
# w.hall[1] = l
# w.rooms[0][1] = nil

# l = w.rooms[1][0]
# w.hall[3] = l
# w.rooms[1][0] = nil
# pp w.next_moves

def min_energy(world, energy_used=0, cache={})
  if world.done?
    return 0
  end

  if cache[world.token]
    return cache[world.token] >= 0 ? cache[world.token] : nil
  end

  next_moves = world.next_moves
  if next_moves.size == 0
    cache[world.token] = -1
    return nil
  end

  energies = {}
  # puts "Checking #{next_moves.size} for #{world.token}"
  next_moves.each do |next_move|
    new_world, new_energy_used = next_move
    min_for_move = min_energy(new_world, 0, cache)
    energies[new_energy_used + min_for_move] = new_world.token if min_for_move
  end

  min_energy = energies.keys.min
  cache[world.token] = min_energy ? (energy_used + min_energy) : -1
  # pp "#{world.token} is #{min_energy} from #{energies[min_energy]}"

  # pp "me #{min_energy} for #{world.token}"
  min_energy
end

cache = {}
data =File.read('day23.txt')
puts min_energy(world_from_data(data), 0, cache)
# puts cache

# w = World.new([['A', 'A'], ['B', 'B'], ['C', 'C'], ['D', 'D']], [])
# puts w.done?

40   -12095
4    -12055
3000 -12051
30
40   - 9051
2003 - 9011
7000 - 7008
8