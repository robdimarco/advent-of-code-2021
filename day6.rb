data = File.read('day6.txt').split(',').map(&:to_i)
# data = "3,4,3,1,2".split(',').map(&:to_i)


def blank_count_hash
  (0..8).each_with_object({}) do |i, hsh|
    hsh[i] = 0
  end
end
data_by_count = blank_count_hash

data.each do |fish|
  data_by_count[fish] += 1
end
# puts data_by_count

def add_day(data)
  rv = []
  data.each do |fish|
    if fish > 0
      rv << fish -1
    else
      rv << 6
      rv << 8
    end
  end
  rv
end

def add_day_by_count(data_by_count)
  rv = blank_count_hash
  (0..8).each do |k|
    v = data_by_count[k]
    if k > 0
      rv[k-1] += v
    elsif k == 0
      rv[6] = v
      rv[8] = v
    end
  end

  # puts rv
  rv
end

(1..256).each do
  # data = add_day(data)
  data_by_count = add_day_by_count(data_by_count)
  # puts [data.size, data_by_count.values.sum].inspect
end
# puts data.size
puts data_by_count.values.sum