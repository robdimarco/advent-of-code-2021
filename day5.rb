data = File.read('day5.txt')
# data = <<~EOM
# 0,9 -> 5,9
# 8,0 -> 0,8
# 9,4 -> 3,4
# 2,2 -> 2,1
# 7,0 -> 7,4
# 6,4 -> 2,0
# 0,9 -> 2,9
# 3,4 -> 1,4
# 0,0 -> 8,8
# 5,5 -> 8,2
# EOM

Point = Struct.new(:x, :y)
Line = Struct.new(:start_point, :end_point) do
  def vertical?
    start_point.x == end_point.x
  end

  def horizontal?
    start_point.y == end_point.y
  end

  def straight?
    horizontal? || vertical?
  end

  def points
    rv = []
    x_diff = (end_point.x - start_point.x)
    x_dir = x_diff != 0 ? x_diff / x_diff.abs : 0

    y_diff = (end_point.y - start_point.y)
    y_dir = y_diff != 0 ? y_diff / y_diff.abs : 0

    x_idx = start_point.x
    y_idx = start_point.y

    loop do
      p = Point.new(x_idx, y_idx)
      rv << p
      break if end_point.x == p.x && end_point.y == p.y
      x_idx += x_dir
      y_idx += y_dir
    end

    rv
  end
end

def data_to_lines(data)
  data.lines.map do |line|
    points = line.strip.split(' -> ').map {|p| k = p.split(','); Point.new(k[0].to_i, k[1].to_i)}
    Line.new(points[0], points[1])
  end
end

def intersection_map(lines)
  rv = {}
  lines.each do |line|
    line.points.each do |p|
      rv[[p.x, p.y]] ||= 0
      rv[[p.x, p.y]] += 1
    end
  end
  rv
end

def intersections(lines)
  rv = intersection_map(lines)
  rv.keys.select {|k| rv[k] > 1}.size
end

def dump_map(lines)
  ints = intersection_map(lines)

  (0..9).each do |y|
    (0..9).each do |x|
      print ints[[x,y]] || '.'
    end
    puts ""
  end
end

lines = data_to_lines(data)
puts intersections(lines)
# puts lines[0].points.map(&:to_s)
# puts lines[1].points.map(&:to_s)
# puts lines[2].points
# puts lines[4].points
