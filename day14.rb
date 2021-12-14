data = <<~EOM
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
EOM

data = File.read('day14.txt')
template, rules = data.split("\n\n")
rules = Hash[rules.lines.map {|p| p.strip.split(' -> ')}]

def step(base, rules)
  rv = [base[0]]
  (1...base.length).each do |i|
    pair = base[i-1..i]
    rv << rules[pair]
    rv << base[i]
  end

  rv.join
end
# puts template
# puts rules.inspect
pairs = {template[-1] => 1}
pair_counts = (0...(template.length - 1)).each_with_object(pairs) do |i, hsh|
  pair = template[i..i+1]
  hsh[pair] ||= 0
  hsh[pair] += 1
end

def step2(pair_counts, rules)
  pair_counts.keys.each_with_object({}) do |pair, hsh|
    insert = rules[pair]
    # puts "have #{insert}"
    if insert
      k1 = [pair[0], insert].join
      k2 = [insert, pair[1]].join
      hsh[k1] ||= 0
      hsh[k1] += pair_counts[pair]
      hsh[k2] ||= 0
      hsh[k2] += pair_counts[pair]

      # puts "adding #{k1} and #{k2}"
    else
      hsh[pair] = pair_counts[pair]
    end
  end
end

# puts pair_counts
# puts step2(pair_counts, rules)
40.times do
  pair_counts = step2(pair_counts, rules)
#   b = step(b, rules)
end

counts = pair_counts.keys.each_with_object({}) do |pair, h|
  h[pair[0]] ||= 0
  h[pair[0]] += pair_counts[pair]
end
# puts pair_counts
# puts counts

# 1588 for example data, 2375 for input
puts counts.values.max - counts.values.min
# puts b =='NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB'