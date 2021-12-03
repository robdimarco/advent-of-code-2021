vals = File.open('day2.txt').each_line.map {|l| l.strip.split(' ')}
# vals = [['forward', 5], ['down', 5], ['forward', 8], ['up', 3], ['down', 8], ['forward', 2]]
pos = [0,0,0]
vals.each do |(command, num)|
  num = num.to_i
  case command
  when 'forward'
    pos[0] += num
    pos[1] += num * pos[2]
  when 'down'
    pos[2] += num
  when 'up'
    pos[2] -= num
  else
    raise "doh #{command}"
  end
end
puts pos[0..1].reduce(:*)
