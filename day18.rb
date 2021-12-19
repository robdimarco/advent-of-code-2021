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

def max_magnitude(data)
  lines =  data.lines
  max = -1
  (0...lines.size).each do |n|
    (0...lines.size).each do |m|
      next if m == n
      val = magnitude(add(eval(lines[n]), eval(lines[m])))
      # puts "val: #{val} from #{n} + #{m}"
      max = [max, val].max
    end
  end
  return max
end

pp max_magnitude(data)

