def execute(instructions, input)
  input = input.dup
  vals = {'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0}
  instructions.each do |inst|
    cmd, a, b = inst
    b_val = vals.key?(b) ? vals[b] : b.to_i
    #puts "state #{vals} inst #{inst} and input #{input}"
    case cmd
    when 'inp'
      vals[a] = input.shift.to_i
    when 'add'
      vals[a] += b_val
    when 'mul'
      vals[a] *= b_val
    when 'div'
      vals[a] /= b_val
    when 'mod'
      vals[a] %= b_val
    when 'eql'
      # puts "vals #{a} = #{vals[a]} == #{b} #{vals[b]} #{vals[a] == vals[b]}"
      vals[a] = vals[a] == b_val ? 1 : 0
    else
      raise "Invalid cmd #{cmd}"
    end
  end
  vals
end

data = <<~EOM
inp w
add z w
mod z 2
div w 2
add y w
mod y 2
div w 2
add x w
mod x 2
div w 2
mod w 2
EOM
data = File.read('day24.txt')

instructions = data.lines.map {|l| l.strip.split(' ')}
cnt = 99_999_999_999_999
while cnt >= 0 do
  vals = execute(instructions, cnt.to_s.rjust(14, '0').chars.map(&:to_i))
  if vals['z'] == 0
    pp "Eureka #{cnt} #{vals}"
    break
  end
  print '.' if cnt % 1000 == 0
  cnt -= 1
end
# puts execute(instructions, [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4])