vals = File.open('day3.txt').each_line.map {|l| l.strip.chars}
# vals = "00100
# 11110
# 10110
# 10111
# 10101
# 01111
# 00111
# 11100
# 10000
# 11001
# 00010
# 01010".each_line.map {|l| l.strip.chars}

counts = {}
vals.each do |v|
  v.each_with_index do |c, i|
    counts[i] ||= {}
    counts[i][c] ||= 0
    counts[i][c] += 1
  end
end

gamma = []
epsilon = []
counts.keys.each do |k|
  count_for_key = counts[k]
  gamma << count_for_key.keys.max_by {|kk| count_for_key[kk]}
  epsilon << count_for_key.keys.min_by {|kk| count_for_key[kk]}
end

puts gamma.join.to_i(2) * epsilon.join.to_i(2)

oxygen = nil
co2 = nil

ox_vals = vals.dup
co2_vals = vals.dup

idx = 0
loop do
  counts = {}
  ox_vals.each do |v|
    c = v[idx]
    counts[c] ||= 0
    counts[c] += 1
  end
  max_val = counts['1'] == counts['0'] ? '1' : counts.keys.max_by {|k| counts[k]}
  # break
  ox_vals.select! {|v| v[idx] == max_val}
  # puts [counts, max_val, ox_vals.map(&:join), idx]
  if ox_vals.size == 1
    oxygen = ox_vals.first
    break;
  end
  idx += 1
end

idx = 0
loop do
  counts = {}
  co2_vals.each do |v|
    c = v[idx]
    counts[c] ||= 0
    counts[c] += 1
  end
  min_val = counts['1'] == counts['0'] ? '0' : counts.keys.min_by {|k| counts[k]}
  # break
  co2_vals.select! {|v| v[idx] == min_val}
  # puts [counts, max_val, co2_vals.map(&:join), idx]
  if co2_vals.size == 1
    co2 = co2_vals.first
    break;
  end
  idx += 1
end

# gamma.each_with_index do |k, idx|

# end

puts oxygen.join.to_i(2)*  co2.join.to_i(2)
