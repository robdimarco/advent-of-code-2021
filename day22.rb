
Cube = Struct.new(:direction, :x_bounds, :y_bounds, :z_bounds) do
  def overlap(other)
    return nil if x_bounds[0] > other.x_bounds[1] || x_bounds[1] < other.x_bounds[0]
    return nil if y_bounds[0] > other.y_bounds[1] || y_bounds[1] < other.y_bounds[0]
    return nil if z_bounds[0] > other.z_bounds[1] || z_bounds[1] < other.z_bounds[0]
    xmin = [x_bounds[0], other.x_bounds[0]].max
    xmax = [x_bounds[1], other.x_bounds[1]].min
    ymin = [y_bounds[0], other.y_bounds[0]].max
    ymax = [y_bounds[1], other.y_bounds[1]].min
    zmin = [z_bounds[0], other.z_bounds[0]].max
    zmax = [z_bounds[1], other.z_bounds[1]].min

    Cube.new(nil, [xmin, xmax], [ymin, ymax], [zmin, zmax])
  end

  def volume
    (x_bounds[1] - x_bounds[0] + 1) * (y_bounds[1] - y_bounds[0] + 1) * (z_bounds[1] - z_bounds[0] + 1)
  end

  def on?
    direction == 'on'
  end
end

def parse(raw)
  raw.lines.map do |l|
    cmd, rest = l.strip.split(' ')
    dims = rest.split(',')
    coords = dims.map {|d| d.split('=').last.split('..').map(&:to_i)}
    Cube.new(cmd, *coords)
  end
end

def apply(cubes)
  applied = []
  cubes.each do |cube|
    other_applies = []
    applied.each do |applied_cube|
      overlap = cube.overlap(applied_cube)
      next unless overlap
      # pp "found overlap of #{overlap}"
      overlap.direction = applied_cube.direction == 'on' ? 'off' : 'on'
      other_applies << overlap
    end

    applied << cube if cube.on?
    applied += other_applies
  end
  # pp applied

  applied.reduce(0) do |acc, cube|
    val = (cube.on? ? cube.volume : -cube.volume)
    # puts "adding #{val}"
    acc + val
  end
end


# pp parse(data)
apply([
  Cube.new('on', [10, 12], [10, 12], [10, 12]),
  Cube.new('on', [11, 13], [11, 13], [11, 13]),
  Cube.new('off', [9,11], [9,11], [9,11]),
  Cube.new('on', [10,10], [10,10], [10,10]),
])
data = <<~EOM
on x=-20..26,y=-36..17,z=-47..7
on x=-20..33,y=-21..23,z=-26..28
on x=-22..28,y=-29..23,z=-38..16
on x=-46..7,y=-6..46,z=-50..-1
on x=-49..1,y=-3..46,z=-24..28
on x=2..47,y=-22..22,z=-23..27
on x=-27..23,y=-28..26,z=-21..29
on x=-39..5,y=-6..47,z=-3..44
on x=-30..21,y=-8..43,z=-13..34
on x=-22..26,y=-27..20,z=-29..19
off x=-48..-32,y=26..41,z=-47..-37
on x=-12..35,y=6..50,z=-50..-2
off x=-48..-32,y=-32..-16,z=-15..-5
on x=-18..26,y=-33..15,z=-7..46
off x=-40..-22,y=-38..-28,z=23..41
on x=-16..35,y=-41..10,z=-47..6
off x=-32..-23,y=11..30,z=-14..3
on x=-49..-5,y=-3..45,z=-29..18
off x=18..30,y=-20..-8,z=-3..13
on x=-41..9,y=-7..43,z=-33..15
on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
on x=967..23432,y=45373..81175,z=27513..53682
EOM
data = File.read('day22.txt')
cubes = parse(data)

# cubes = cubes.map {|c| o = c.overlap(Cube.new(nil, [-50, 50], [-50, 50], [-50, 50])); if o; o.direction = c.direction; end; o}.compact

pp apply(cubes)