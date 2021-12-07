data = File.read('day7.txt').split(',').map(&:to_i)
# data = "16,1,2,0,4,2,7,1,2,14".split(',').map(&:to_i)
@move_costs = {}

def move_cost(i)
  return 0 if i <= 0

  @move_costs[i] ||= move_cost(i - 1) + i
end

def fuel_required_1(data, pos)
  data.map {|p| (p - pos).abs}.sum
end
def fuel_required_2(data, pos)
  data.map {|p| move_cost((p - pos).abs)}.sum
end

def part_1(data)
  min_pos = (0..data.max).min_by {|pos| fuel_required_1(data, pos)}
  puts [min_pos, fuel_required_1(data, min_pos)].inspect
end

def part_2(data)
  min_pos = (0..data.max).min_by {|pos| fuel_required_2(data, pos)}
  puts [min_pos, fuel_required_2(data, min_pos)].inspect
end

# part_1(data)
part_2(data)