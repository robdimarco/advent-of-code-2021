data = <<~EOM
2199943210
3987894921
9856789892
8767896789
9899965678
EOM
data = File.read('day9.txt')

grid = data.lines.map do |line|
  line.strip.chars.map(&:to_i)
end

def low_point?(grid, x, y)
  rv = true

  check_at = [[x-1, y], [x+1, y], [x, y - 1], [x, y + 1]]
  # puts "looking at #{check_at.inspect}"
  check_at.all? {|(x1, y1)| x1 < 0 || y1 < 0 || x1 >= grid[0].size || y1 >= grid.size || grid[y1][x1] > grid[y][x] }
end


def find_low_points(grid)
  l =
  all_low_points = []
  (0...grid[0].size).each do |x|
    (0...grid.size).each do |y|
      # puts "check #{x}, #{y}"
      if low_point?(grid, x, y)

        all_low_points << [x, y, grid[y][x]]
      end
    end
  end
  all_low_points
end
puts find_low_points(grid).reduce(0) {|acc, p| acc + p[2] + 1}

