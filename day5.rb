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
    if horizontal?
      diff = (end_point.x - start_point.x)
      dir = diff / diff.abs
      idx = start_point.x
      loop do
        p = Point.new(idx, start_point.y)
        rv << p
        break if end_point.x == p.x
        idx += dir
      end
    elsif vertical?
      diff = (end_point.y - start_point.y)
      dir = diff / diff.abs
      idx = start_point.y
      loop do
        p = Point.new(start_point.x, idx)
        rv << p
        break if end_point.y == p.y
        idx += dir
      end
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

def intersections(lines)
  rv = {}
  lines.each do |line|
    line.points.each do |p|
      rv[[p.x, p.y]] ||= 0
      rv[[p.x, p.y]] += 1
    end
  end

  rv.keys.select {|k| rv[k] > 1}
end

puts intersections(data_to_lines(data)).size #map(&:to_s)

# puts lines[0].points
# puts lines[2].points
# puts lines[4].points
