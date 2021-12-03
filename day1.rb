vals = File.open('day1.txt').each_line.map {|l| l.strip.to_i}
cnt = 0
(1..vals.length - 2).each do |idx|
  prev_window = vals[idx - 1..idx+1].sum
  cur_window = vals[idx..idx+2].sum
  puts [prev_window, cur_window].join(" <> ")
  cnt += 1 if cur_window > prev_window
end
puts cnt