TRANSFORMS = [
  {0=>[0,1],  1 => [1,1],  2=>[2,1]},
  {0=>[0,1],  1 => [1,1],  2=>[2,-1]},
  {0=>[0,1],  1 => [1,-1], 2=>[2,1]},
  {0=>[0,1],  1 => [1,-1], 2=>[2,-1]},
  {0=>[0,-1], 1 => [1,1],  2=>[2,1]},
  {0=>[0,-1], 1 => [1,1],  2=>[2,-1]},
  {0=>[0,-1], 1 => [1,-1], 2=>[2,1]},
  {0=>[0,-1], 1 => [1,-1], 2=>[2,-1]},

  {0=>[0,1],  1 => [2,1],  2=>[1,1]},
  {0=>[0,1],  1 => [2,-1], 2=>[1,1]},
  {0=>[0,1],  1 => [2,1],  2=>[1,-1]},
  {0=>[0,1],  1 => [2,-1], 2=>[1,-1]},
  {0=>[0,-1], 1 => [2,1],  2=>[1,1]},
  {0=>[0,-1], 1 => [2,-1], 2=>[1,1]},
  {0=>[0,-1], 1 => [2,1],  2=>[1,-1]},
  {0=>[0,-1], 1 => [2,-1], 2=>[1,-1]},

  {0=>[1,1],  1 => [0,1],  2=>[2,1]},
  {0=>[1,1],  1 => [0,1],  2=>[2,-1]},
  {0=>[1,1],  1 => [0,-1], 2=>[2,1]},
  {0=>[1,1],  1 => [0,-1], 2=>[2,-1]},
  {0=>[1,-1], 1 => [0,1],  2=>[2,1]},
  {0=>[1,-1], 1 => [0,1],  2=>[2,-1]},
  {0=>[1,-1], 1 => [0,-1], 2=>[2,1]},
  {0=>[1,-1], 1 => [0,-1], 2=>[2,-1]},

  {0=>[1,1],  1 => [2,1],  2=>[0,1]},
  {0=>[1,1],  1 => [2,1],  2=>[0,-1]},
  {0=>[1,1],  1 => [2,-1], 2=>[0,1]},
  {0=>[1,1],  1 => [2,-1], 2=>[0,-1]},
  {0=>[1,-1], 1 => [2,1],  2=>[0,1]},
  {0=>[1,-1], 1 => [2,1],  2=>[0,-1]},
  {0=>[1,-1], 1 => [2,-1], 2=>[0,1]},
  {0=>[1,-1], 1 => [2,-1], 2=>[0,-1]},

  {0=>[2,1],  1 => [0,1],  2=>[1,1]},
  {0=>[2,1],  1 => [0,1],  2=>[1,-1]},
  {0=>[2,1],  1 => [0,-1], 2=>[1,1]},
  {0=>[2,1],  1 => [0,-1], 2=>[1,-1]},
  {0=>[2,-1], 1 => [0,1],  2=>[1,1]},
  {0=>[2,-1], 1 => [0,1],  2=>[1,-1]},
  {0=>[2,-1], 1 => [0,-1], 2=>[1,1]},
  {0=>[2,-1], 1 => [0,-1], 2=>[1,-1]},

  {0=>[2,1],  1 => [1,1],  2=>[0,1]},
  {0=>[2,1],  1 => [1,1],  2=>[0,-1]},
  {0=>[2,1],  1 => [1,-1], 2=>[0,1]},
  {0=>[2,1],  1 => [1,-1], 2=>[0,-1]},
  {0=>[2,-1], 1 => [1,1],  2=>[0,1]},
  {0=>[2,-1], 1 => [1,1],  2=>[0,-1]},
  {0=>[2,-1], 1 => [1,-1], 2=>[0,1]},
  {0=>[2,-1], 1 => [1,-1], 2=>[0,-1]},
]
  # {0=>[1,-1], 1=> [2, -1], 2=>[0, 1]}

  # {0=>[2, 1], 1 => [0,-1], 2=>[1, -1]}

def parse(data)
  rv = {}
  data.lines.each do |line|
    next if line.strip == ''
    re = /scanner (\d+)/
    m = re.match(line)
    if m
      rv[m[1]] = []
    else
      rv[rv.keys.last] += [line.strip.split(',').map(&:to_i)]
    end
  end
  rv
end

def distances(points)
  rv = {}
  points.each do |p1|
    points.each do |p2|
      next if p1 == p2
      key = [p1, p2].sort
      next if rv[key]

      rv[key] = distance_from(p1, p2)
    end
  end
  rv
end

def distance_from(p1, p2)
  d = 0
  (0...p1.length).each do |idx|
    x1 = p1[idx]
    x2 = p2[idx]
    d += (x1 - x2)**2
  end

  d ** 0.5
end

def find_matching_points(pmap1, pmap2)
  distances1 = distances(pmap1)
  distances2 = distances(pmap2)
  matches = {}
  distances1.each do |(points, distance)|
    matches[distance] ||= []
    matches[distance] << {source: :first, points: points}
  end
  distances2.each do |(points, distance)|
    matches[distance] << {source: :second, points: points} if matches[distance]
  end

  matches.keys.each do |k|

    unless matches[k].detect {|h| h[:source] == :second}
      matches.delete(k)
    end
  end

  matches
end

def transformation_analysis(distance_to_points_map)
  transform_counts = Hash.new(0)
  distance_to_points_map.each do |(distance, matching_points)|
    first_matches, second_matches = matching_points.partition {|m| m[:source] == :first}

    first_matches.each do |points|
      points[:points].each do |point|
        TRANSFORMS.each do |transform_hash|
          new_point = []
          point.size.times do |i|
            pos, rot = transform_hash[i]
            val = rot * point[pos]
            # pp "pos #{pos} rot #{rot} point #{point[pos]} val #{val}" if rot < 0
            new_point << val
          end

          second_matches.each do |spoints|
            spoints[:points].each do |sp|
              offset = []
              sp.size.times do |i|
                offset << sp[i] - new_point[i]
              end
              transform_counts[[transform_hash, offset]] += 1
            end

          end
        end
      end
    end
  end

  best_transform = transform_counts.keys.max_by {|k| transform_counts[k]}
end

def add_points(map1, map2)
  matching_points = find_matching_points(map2, map1)
  rotation_hash, offset = transformation_analysis(matching_points)

  rv = map1.dup
  map2.each do |point|
    new_point = []
    point.size.times do |i|
      pos, rot = rotation_hash[i]
      new_point << point[pos] * rot + offset[i]
    end
    unless rv.include?(new_point)
      # pp "Adding #{new_point} with offset #{offset} from #{point} and rotation #{rotation_hash}"
      rv.push(new_point)
    end
  end
  [rv, offset]
end

data = <<~EOM
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
EOM
data = File.read('day19.txt')
point_map = parse(data)

vals = point_map.values

def best_match_index(map, vals)
  best_match = nil
  (0...vals.size).each do |b|
    count = find_matching_points(map, vals[b]).size
    best_match = [b, count] if best_match.nil? || best_match[1] < count
  end

  best_match
end

offsets = [[0,0,0]]

while vals.size > 1 do
  map1 = vals[0]
  vals.delete_at(0)
  cmp = best_match_index(map1, vals)

  map2 = vals[cmp[0]]
  vals.delete_at(cmp[0])

  merged, offset = add_points(map1, map2)
  offsets += [offset]
  vals = [merged] + vals
end
pp vals.first.size

def greatest_manhattan(offsets)
  distances = []
  (0...offsets.size - 1).each do |a|
    ((a+1)...offsets.size).each do |b|
      distance = 0
      o1 = offsets[a]
      o2 = offsets[b]
      (0...o1.size).each do |i|
        distance += (o1[i] - o2[i]).abs
      end
      # pp "o1 #{o1} to o2 #{o2} is #{distance}"
      distances << distance
    end
  end
  distances.max
end
pp greatest_manhattan(offsets)
