data = <<~EOM
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
EOM
data = File.read('day13.txt')
points = []
folds = []
data.lines.each do |row|
  row = row.strip
  if row.include?(',')
    points += [row.split(',').map(&:to_i)]
  elsif row.include?('fold along')
    vals = row.split(' ')[-1].split('=')
    folds += [[vals[0], vals[1].to_i]]
  end
end
# puts points.inspect
# puts folds.inspect

def print_hash(points)
  max_x = points.map {|r| r[0]}.max
  max_y = points.map {|r| r[1]}.max

  (0..max_y).each do |y|
    (0..max_x).each do |x|
      if points.include?([x, y])
        print '#'
      else
        print '.'
      end
    end
    puts
  end
end

def fold(points, fold)
  direction, val = fold
  if direction == 'y'
    points.each do |point|
      if point[1] > val
        point[1] = 2 * val - point[1]
      end
    end
  else
    points.each do |point|
      if point[0] > val
        point[0] = 2 * val - point[0]
      end
    end
  end
  points
end

folds.each do |f|
  fold(points, f)
  puts points.uniq.size
end



print_hash(points)
