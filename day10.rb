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

puts lines.map {|l| validate_line(l, pairs)}.compact.map {|c| scores[c]}.sum
