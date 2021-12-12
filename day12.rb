dirs = <<~EOM
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
EOM
dirs = File.read('day12.txt')

dirs = dirs.lines.map(&:strip)
path_map = dirs.each_with_object({}) do |dir, obj|
  a, b = dir.split('-')
  obj[a] ||= []
  obj[b] ||= []
  obj[a] << b
  obj[b] << a
end

full_paths = []
path_to_map = ['start']

def next_steps(path_map, current_path)
  path_map[current_path[-1]].select do |p|
    next true if p.upcase == p

    match_cnt = current_path.count {|cp| cp == p }
    next true if match_cnt == 0

    next false if %w(start end).include?(p)

    current_path.reject {|p| p.upcase == p}.group_by {|s| s}.values.map(&:size).max < 2
  end
end

def all_next_steps(path_map, current_path)
  next_steps(path_map, current_path).map do |step|
    current_path + [step]
  end
end

def find_full_paths(path_map)
  current_paths = [['start']]
  end_paths = []
  loop do
    next_paths = []
    current_paths.each do |current_path|
      new_paths = all_next_steps(path_map, current_path)
      if new_paths.any?
        new_end_paths, open_paths = new_paths.partition {|p| p[-1] == 'end'}
        end_paths += new_end_paths
        next_paths += open_paths
      end
    end
    break if next_paths.empty?
    current_paths = next_paths
  end
  end_paths
end

puts find_full_paths(path_map).size

