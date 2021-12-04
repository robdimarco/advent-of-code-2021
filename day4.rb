data = File.read('day4.txt').lines.map(&:strip)

# data = <<~EOM.lines.map(&:strip)
# 7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

# 22 13 17 11  0
#  8  2 23  4 24
# 21  9 14 16  7
#  6 10  3 18  5
#  1 12 20 15 19

#  3 15  0  2 22
#  9 18 13 17  5
# 19  8  7 25 23
# 20 11 10 24  4
# 14 21 16 12  6

# 14 21 17 24  4
# 10 16 15  9 19
# 18  8 23 26 20
# 22 11 13  6  5
#  2  0 12  3  7
# EOM
numbers = data.shift.split(',').map(&:to_i)

class Board
  attr_reader :rows, :last_number, :is_last
  def initialize
    @rows = []
    @last_number = nil
    @is_last = false
  end

  def add_row(line)
    @rows << line.split(/\s+/).map {|n| Square.new(n.to_i, false)}
  end

  def score
    rows.flatten.reject(&:marked).map(&:number).sum * @last_number
  end

  def bingo?
    return true if rows.any? {|r| r.all?(&:marked)}
    (0...rows.first.length).each do |idx|
      return true if rows.all? { |r| r[idx].marked }
    end
    false
  end

  def mark_as_last
    @is_last = true
  end

  def mark(number)
    @last_number = number
    @rows.each do |r|
      r.each do |s|
        if s.number == number
          s.marked = true
        end
      end
    end
  end
end

Square = Struct.new(:number, :marked)

def get_boards(data)
  boards = []
  currentBoard = nil
  loop do
    break if data.empty?
    line = data.shift
    if line.strip == ""
      currentBoard = Board.new
      boards << currentBoard
    else
      currentBoard.add_row(line)
    end
  end
  boards
end

def find_bingo(boards, numbers)
  numbers.each do |n|
    boards.each do |b|
      b.mark(n)
      if b.bingo?
        return b;
      end
    end
  end
end

def last_bingo(boards, numbers)
  numbers.each do |n|
    boards.each do |b|
      b.mark(n)
    end
    no_bingos = boards.reject(&:bingo?)
    if no_bingos.size == 1
      no_bingos.first.mark_as_last
    elsif no_bingos.size == 0
      return boards.detect(&:is_last)
    end

  end
end

boards = get_boards(data)

puts "first score #{find_bingo(boards, numbers).score}"
puts "last score #{last_bingo(boards, numbers).score}"


