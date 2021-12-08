data = <<~EOM
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
EOM
data = File.read('day8.txt')

def clean_string(s)
  s.lines.map {|r| r.split(' | ').map {|p| p.split(' ')}}
end
cleaned_data = clean_string(data)
# puts cleaned_data.inspect

def count_easy_numbers(data)
  data.reduce(0) do |cnt, row|
    digits = row[-1]
    cnt += digits.select {|d| [2, 4, 3, 7].include?(d.length)}.size
  end
end

# puts count_easy_numbers(cleaned_data)

class String
  def sorted
    chars.sort.join
  end

  def sinclude?(s2)
    s2.chars.all? {|c| include?(c)}
  end
end

def find_digits(row)
  all_numbers, digits = row
  num_map = {}
  num_map[1] = all_numbers.detect {|n| n.length == 2}
  num_map[4] = all_numbers.detect {|n| n.length == 4}
  num_map[7] = all_numbers.detect {|n| n.length == 3}
  num_map[8] = all_numbers.detect {|n| n.length == 7}
  all_numbers.select {|n| n.length == 6 }.each do |n|
    if n.sinclude?(num_map[4])
      num_map[9] = n
    elsif n.sinclude?(num_map[7])
      num_map[0] = n
    else
      num_map[6] = n
    end
  end

  all_numbers.select {|n| n.length == 5}.each do |n|
    if n.sinclude?(num_map[7])
      num_map[3] = n
    elsif num_map[9].sinclude?(n)
      num_map[5] = n
    else
      num_map[2] = n
    end
  end

  digits.map do |d|
    num_map.keys.detect do |k|
      v = num_map[k]
      k if v.sorted == d.sorted
    end
  end.join.to_i
end

def sum_digits(cleaned_data)
  cleaned_data.map do |row|
    d = find_digits(row)
    puts d
    d
  end.sum
end

puts sum_digits(cleaned_data)