data = <<~EOF
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
EOF
data = File.read('day10.txt')

lines = data.lines.map(&:strip)
pairs = {
  '(' => ')',
  '{' => '}',
  '[' => ']',
  '<' => '>',
}
scores = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}

close_scores = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4,
}

def validate_line(line, pairs)
  stack = []
  line.chars.each do |c|
    if pairs.key?(c)
      # puts "push #{c}"
      stack.push c
    else
      top = stack.pop
      # puts "compare c to #{pairs[top]}"
      return c unless pairs[top] == c
    end
  end
  nil
end

puts lines.map {|l| validate_line(l, pairs)}.compact.map {|l| scores[l]}.sum
incomplete = lines.reject {|l| validate_line(l, pairs)}

vals = incomplete.map do |line|
  stack = []
  line.chars.each do |c|
    if pairs.key?(c)
      # puts "push #{c}"
      stack.push c
    else
      top = stack.pop
      # puts "compare c to #{pairs[top]}"
      break unless pairs[top] == c
    end
  end

  total_score = 0
  while stack.size > 0 do
    c = stack.pop
    total_score *= 5
    total_score += close_scores[pairs[c]]
  end
  total_score
end

puts vals.sort[vals.size/2]