data = File.read('day6.txt').split(',').map(&:to_i)
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

(1..80).each do
  data = add_day(data)
end
puts data.size