data = File.read('day7.txt').split(',').map(&:to_i)
# data = "16,1,2,0,4,2,7,1,2,14".split(',').map(&:to_i)

def fuel_required(data, pos)
  data.map {|p| (p - pos).abs}.sum
end


min_pos = (0..data.max).min_by {|pos| fuel_required(data, pos)}
puts [min_pos, fuel_required(data, min_pos)].inspect