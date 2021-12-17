data = "target area: x=20..30, y=-10..-5"
data = File.read('day17.txt')

_, _, x_raw, y_raw = data.split(' ')
x_range = x_raw.scan(/[\-\d]+/).map(&:to_i)
y_range = y_raw.scan(/[\-\d]+/).map(&:to_i)

target = [x_range, y_range]

def step(position, velocity)
  position[0] += velocity[0]
  position[1] += velocity[1]
  if velocity[0] > 0
    velocity[0] -= 1
  elsif velocity[0] < 0
    velocity[0] += 1
  end

  velocity[1] -= 1

  [position, velocity]
end

def hits_target?(position, target)
  position[0] >= target[0].min && position[0] <= target[0].max && position[1] >= target[1].min && position[1] <= target[1].max
end

def missed_target?(position, target)
  return true if position[1] < target[1].min
end

def max_height(velocity, target)
  position = [0, 0]
  max_height = 0
  # puts target.inspect
  loop do
    return false if missed_target?(position, target)
    return max_height if hits_target?(position, target)

    position, velocity = step(position, velocity)
    max_height = [max_height, position[1]].max
    # puts position.inspect
  end
end

mmh = 0
biggest_y = 0
100000.times do
  x = rand(x_range.max) + 1
  y = biggest_y + rand(y_range.max.abs)
  mh = max_height([x, y], target)
  # puts [x, y].inspect
  next unless mh
  if mh > mmh
    puts [x,y].inspect
    biggest_y = y
    mmh = mh
  end
end
puts mmh