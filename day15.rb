data = <<~EOM
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
EOM

data = File.read('day15.txt')

risks_array = data.lines.map {|l| l.strip.chars.map(&:to_i)}
row_count = risks_array.length
col_count = risks_array[0].length

risks = {}
(0...row_count).each do |row|
  (0..col_count).each do |col|
    risks[[row, col]] = risks_array[row][col]
  end
end


to_check = [[0,0]]
best_paths = {[0,0] => {path: [[0,0]], risk: 0}}
loop do
  checking = to_check.shift
  break if checking.nil?
  row, col = checking
  path = best_paths[checking][:path]
  risk = best_paths[checking][:risk]

  [[-1, 0], [1,0], [0, -1], [0, 1]].each do |(d_row, d_col)|
    nrow = row + d_row
    ncol = col + d_col
    next if nrow < 0 || nrow >= row_count || ncol < 0 || ncol >= col_count
    new_pos = [nrow, ncol]
    risk_at_npos = risks[new_pos] + risk
    if best_paths[new_pos].nil? || best_paths[new_pos][:risk] > risk_at_npos
      best_paths[new_pos] = {
        path: path + [new_pos],
        risk: risk_at_npos
      }
      to_check.push new_pos
    end
  end
  # check all moves from position
  # If no value or better than current value...
  # Set new path.
  # Check from there....
end
puts best_paths[[row_count - 1, col_count - 1]]
