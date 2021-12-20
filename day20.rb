data = <<~EOM
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

...............
...............
...............
...............
...............
.....#..#......
.....#.........
.....##..#.....
.......#.......
.......###.....
...............
...............
...............
...............
...............
EOM

def parse(data)
  lines = data.lines
  {
    algo: lines[0].strip,
    image: lines[2..-1].map(&:strip).reject{|l| l.empty?}.map(&:chars),
  }
end

def pixel(algo, raw_data, position, iter)
  byte = ""
  (-1..1).each do |drow|
    (-1..1).each do |dcol|
      row = position[0] + drow
      col = position[1] + dcol
      if row < 0 || row >= raw_data.size || col < 0 || col >= raw_data[0].size
        byte << (iter % 2 == 0 || algo[0] == '.' ? '0' : '1')
        next
      end
      byte << (raw_data[row][col] == '.' ? '0' : '1')
    end
  end

  algo[byte.to_i(2)]
end

def transform(algo, data, iter)
  rv = []
  (-1..data.size).each do |row|
    rv.push([])
    (-1..data[0].size).each do |col|
      rv.last << pixel(algo, data, [row, col], iter)
    end
  end
  rv
end

def dump(data)
  data.map {|l| l.join("")}.join("\n")
end

data = File.read('day20.txt')

parsed_data = parse(data)
t = parsed_data[:image]
50.times do |i|
  t = transform(parsed_data[:algo], t, i)
end

# puts dump(t2)
puts t.flatten.count {|c| c == '#'}

# ?????
# ?xxx?
# ?xxx?
# ?xxx?
# ?aaa?
# ?????
