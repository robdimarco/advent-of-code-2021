data = <<~EOM
11111
19991
19191
19991
11111
EOM
data = <<~EOM
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
EOM
data = File.read('day11.txt')

class Point
  attr_accessor :value
  def initialize(v)
    @value = v
  end

  def increment
    @value += 1
  end

  def flashed?
    @flashed > 9
  end

  def finalize
    @value = 0 if @value > 9
  end
end

data = data.lines.map {|l| l.strip.chars.map(&:to_i)}

def step(data)
  # increment all
  flashed_count = 0
  to_process = []
  (0...data.size).each do |row|
    (0...data[row].size).each do |col|
      data[row][col] += 1
      if data[row][col] > 9
        flashed_count += 1
        to_process += [[row, col]]
      end
    end
  end

  while to_process.any?
    row, col = to_process.shift
    # puts "row: #{row} col: #{col}"
    [[0,1], [0, -1], [1, 0], [-1, 0], [-1, 1], [1, 1], [-1, -1], [1, -1]].each do |(drow, dcol)|
      rown = drow + row
      coln = dcol + col
      # puts "rown #{rown} coln #{coln}"
      if rown >= 0 && coln >= 0 && rown < data.size && coln < data[rown].size && data[rown][coln] <= 9
        data[rown][coln] += 1
        if data[rown][coln] > 9
          flashed_count += 1
          to_process += [[rown, coln]]
        end
      end
    end
  end

  (0...data.size).each do |row|
    (0...data[row].size).each do |col|
      if data[row][col] > 9
        data[row][col] = 0
      end
    end
  end

  return {flashed_count: flashed_count, data: data}
end

def part1(data)
  total_flashes = 0
  100.times do
    rv = step(data)
    total_flashes += rv[:flashed_count]
    data = rv[:data]
  end
  # puts data.inspect
  puts total_flashes
end

def part2(data)
  cnt = 0
  loop do
    sum = data.flat_map {|row| row.sum }.sum

    return cnt if sum == 0

    cnt +=1
    # puts "cnt: #{cnt} sum #{sum}"
    data = step(data)[:data]
  end
end

puts part2(data)