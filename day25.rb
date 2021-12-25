data = <<~EOM
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
EOM

def dump(sea_floor)
  sea_floor.each {|l| puts l.join}
end

def clone(sea_floor)
  sea_floor.map {|r| r.dup}
end

def step(sea_floor)
  rv = clone(sea_floor)
  (0...sea_floor.size).each do |row|
    sea_floor[row].each_with_index do |val, col|
      next if val != '>'

      next_col = col + 1
      next_col = 0 if next_col == sea_floor[row].size
      next unless rv[row][next_col] == '.' && sea_floor[row][next_col] != '>'

      rv[row][col] = '.'
      rv[row][next_col] = '>'
    end
  end

  (0...sea_floor.size).each do |row|
    sea_floor[row].each_with_index do |val, col|
      next if val != 'v'

      next_row = row + 1
      next_row = 0 if next_row == sea_floor.size
      next unless rv[next_row][col] == '.' && sea_floor[next_row][col] != 'v'

      rv[row][col] = '.'
      rv[next_row][col] = 'v'
    end
  end
  rv
end

data = File.read('day25.txt')
sea_floor = data.lines.map {|l| l.strip.chars}

cnt = 0
loop do
  cnt += 1
  after = step(sea_floor)
  break if after == sea_floor
  # if cnt <= 10
  #   dump(after)
  #   puts
  # else
  #   # break
  # end
  sea_floor = after
end
puts cnt
# dump(step(step(sea_floor)))