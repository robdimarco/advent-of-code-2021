# DeepNumber = Struct.new(:number, :depth, :position)
data = <<~EOM
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
EOM


def sum_list(data)
  data.lines.reduce(nil) do |acc, line|
    array = eval(line)
    if acc.nil?
      acc = array
    else
      acc = add(acc, array)
    end
  end
end

def add(a1, a2)
  arr = [a1, a2]
  reduce(arr)
end

def reduce(n)
  loop do
    n, exploded = explode(n)
    if exploded
      next
    end
    n, did_split = split(n)
    if did_split
      next
    end

    break
  end
  n
end

def find_indexes(val, hsh={}, current_path=[])
  if val.is_a?(Array)
    find_indexes(val[0], hsh, current_path + [0])
    find_indexes(val[1], hsh, current_path + [1])
  else
    hsh[current_path] = hsh.keys.last
  end
  hsh
end

def explode(n)
  tree = find_indexes(n)
  tree.keys.each do |array_indexes|
    if array_indexes.size > 4
      parent_index = array_indexes[0...4]

      left = parent_index + [0]
      right = parent_index + [1]

      next_left = tree[left]
      next_right = tree.invert[right]
      if next_left
        next_left_val = n.dig(*next_left)
        deep_set(n, next_left, next_left_val + n.dig(*left))
      end

      if next_right
        next_right_val = n.dig(*next_right)
        deep_set(n, next_right, next_right_val + n.dig(*right))
      end
      deep_set(n, parent_index,  0)
      return n, true
    end
  end
  return n, false
end

def split(nums)
  tree = find_indexes(nums)

  tree.keys.each do |path|
    value = nums.dig(*path)
    if value >= 10
      deep_set(nums, path,  [value / 2, (value + 1) / 2])
      return nums, true
    end
  end
  return nums, false
end

def deep_set(arr, indices, val)
  current = indices[0]
  rest = indices[1..-1]
  if rest.size > 0
    deep_set(arr[current], rest, val)
  else
    arr[current] = val
  end
  arr
end

def magnitude(val, multiplier=1, current_path=[])
  if val.is_a?(Array)
    magnitude(val[0], multiplier*3, current_path + [0]) +
      magnitude(val[1], multiplier*2, current_path + [1])
  else
    val * multiplier
  end
end


# def find_previous(nums, index)
#   new_index = if index[-1] == 1
#     index[0..-2] + [0]
#   else
#     index[0..-2]
#   end
# end


data = <<~EOM
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
[6,6]
EOM
data = <<~EOM
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
EOM
data = File.read('day18.txt')
summed = sum_list(data)
# inds = find_indexes(summed)

# pp summed
# pp inds
# pp inds.invert
# pp magnitude([[9,1],[1,9]])
pp magnitude(summed)



# def add(p1, p2)
#   arr = p1.map {|n| n.depth += 1; n}
#   p2.each {|n| arr << n; n.depth +=1}
#   pp "base_add: #{dump(arr)}"
#   reduce(arr)
# end

# def explode(nums)
#   # pp "nums #{nums}"
#   nums.each_with_index do |n, idx|
#     if n.depth > 4
#       next_n = nums[idx + 1] # is not nil, same depth as n

#       if idx > 0
#         left_n = nums[idx - 1]
#         left_n.number += n.number
#       end

#       right_n = nums[idx + 2]
#       if right_n
#         puts "setting #{idx + 2} to #{right_n.number + next_n.number }"
#         right_n.number += next_n.number
#       end

#       nums.delete_at(idx + 1)
#       n.number = 0
#       n.depth -= 1
#       prev_val = nums[idx - 1]
#       n.position = prev_val.nil? || prev_val.depth != n.depth || prev_val.position == :right ? :left : :right
#       return nums, true
#     end
#   end
#   return nums, false
# end

# def split(nums)
#   nums.each_with_index do |n, idx|
#     if n.number >= 10

#       nums.insert(idx + 1, DeepNumber.new((n.number + 1)/2, n.depth, :right))
#       n.number = n.number / 2
#       n.depth += 1
#       n.position = :left
#       return nums, true
#     end
#   end
#   return nums, false
# end

# def as_dn(pair)
#   [DeepNumber.new(pair[0], 1, :left), DeepNumber.new(pair[1], 1, :right)]
# end

# def dump(nums)
#   current_depth = 0
#   rv = ''
#   nums.each do |n|
#     # puts "n: #{n} #{current_depth}"
#     if n.position == :left
#       while current_depth >= n.depth do
#         rv << ']'
#         current_depth -= 1
#       end

#       rv << ',' unless rv == ''
#       while current_depth < n.depth do
#         rv << '['
#         current_depth += 1
#       end

#       rv << n.number.to_s

#     elsif n.position == :right
#       rv << ",#{n.number}]"
#       current_depth -= 1
#     end
#   end
#   current_depth.times do
#     rv << ']'
#   end
#   rv
# end

# pp dump(
#   add(
#     [
#       DeepNumber.new(4, 4, :left),
#       DeepNumber.new(3, 4, :right),
#       DeepNumber.new(4, 3, :right),
#       DeepNumber.new(4, 2, :right),
#       DeepNumber.new(7, 2, :left),
#       DeepNumber.new(8, 4, :left),
#       DeepNumber.new(4, 4, :right),
#       DeepNumber.new(9, 3, :right),
#     ],
#     as_dn([1,1])
#   )
# )

# def parse(str)
#   rv = []
#   pos_stack = []
#   str.chars.each do |c|
#     case c
#     when '['
#       pos_stack.push :left
#     when ']'
#       pos_stack.pop
#     when ','
#       # pos_stack.pop
#       # pos_stack.push :right
#     when /[0-9]/
#       position = pos_stack.pop
#       rv << DeepNumber.new(c.to_i, pos_stack.size + 1, position)
#       pos_stack.push :right
#     end
#     pp "#{c}=>#{pos_stack}"
#   end

#   rv
# end
# s = '[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]'

# # pp parse(s)
# # pp parse(s)

# # puts dump(parse(s))
# # puts s


# pp data.lines.reduce([]) {|arr, n| add(arr, parse(n))}
