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

def neighboring_points_in_basin(grid, x, y)
  # puts "checking [#{x}, #{y}]"
  rv = []
  [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |(dx, dy)|
    x1 = dx +x
    y1 = dy +y
    next if x1 < 0 || y1 < 0 || x1 >= grid[0].size || y1 >= grid.size || grid[y1][x1] == 9
    rv << [x1, y1]
  end
  rv
end

def find_basins(grid)
  lps = find_low_points(grid)
  basins = []

  lps.each do |low_point|
    basin = [[low_point[0], low_point[1]]]
    points_to_check = [low_point]
    checked_points = []
    while points_to_check.any? do
      point = points_to_check.shift
      next if checked_points.include?(point)
      checked_points << point
      # puts "points_to_check #{points_to_check}"
      # puts "checked_points #{checked_points}"
      nps = neighboring_points_in_basin(grid, point[0], point[1])
      # puts "np #{nps}"
      nps.each do |np|
        if !basin.include?(np)
          basin << np
          points_to_check << np unless points_to_check.include?(np)
        end
      end
    end
    # puts basin.inspect
    basins << basin
  end
  basins
end
# puts find_low_points(grid).reduce(0) {|acc, p| acc + p[2] + 1}
puts find_basins(grid).map(&:size).sort.reverse[0..2].reduce(:*)

