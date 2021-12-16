HEXA = {
  '0' => '0000',
  '1' => '0001',
  '2' => '0010',
  '3' => '0011',
  '4' => '0100',
  '5' => '0101',
  '6' => '0110',
  '7' => '0111',
  '8' => '1000',
  '9' => '1001',
  'A' => '1010',
  'B' => '1011',
  'C' => '1100',
  'D' => '1101',
  'E' => '1110',
  'F' => '1111',
}
data = 'D2FE28'
data = '38006F45291200'
data = 'EE00D40C823060'
bits = data.chars.map {|c| HEXA[c]}.join

def next_packet(bits)
  # puts "Processing #{bits}"
  pos = 0
  version = bits[0...3].to_i(2)
  packet_type = bits[3...6].to_i(2)
  pos = 6
  packet_value = nil
  if packet_type == 4
    parts = ""
    loop do
      next_part = bits[pos...(pos + 5)]
      parts << next_part[1..-1]
      pos += 5
      break if next_part[0] == '0'
    end
    packet_value = parts.to_i(2)
  else
    length_type_id = bits[6]
    pos += 1
    packet_value = []
    if length_type_id == '0'
      sub_length = bits[7...22].to_i(2)
      pos += 15
      sub_packets = bits[22...(22+sub_length)]
      # pos += sub_length
      loop do
        # puts "get type 0 next packet for #{sub_packets}"
        sub_packet = next_packet(sub_packets)
        packet_value << sub_packet
        packet_length = sub_packets.length - (sub_packet[:remainder]&.length || 0)
        # puts "found packet of length #{packet_length}"
        pos += packet_length
        if sub_packet[:remainder]&.chars&.uniq&.sort != ['0', '1']
          # puts "breaking with remainder #{sub_packet[:remainder]}"
          break
        end

        sub_packets = sub_packet[:remainder]
      end
      # puts "type 0 remainder #{bits[pos..-1]}"
    elsif length_type_id == '1'
      num_of_subpackets = bits[7...18].to_i(2)
      # puts "num_of_subpackets = #{num_of_subpackets}"
      pos += 11
      sub_packets = bits[18..-1]
      num_of_subpackets.times.each do |i|
        # puts "in iteration #{i} of #{num_of_subpackets} at #{pos} of #{bits.length} with subpacket length of #{sub_packets.length}"
        sub_packet = next_packet(sub_packets)
        packet_value << sub_packet
        last_packet_size = sub_packets.length - (sub_packet[:remainder]&.length || 0)
        # puts "last packet size #{last_packet_size} = #{sub_packets.length} - #{(sub_packet[:remainder]&.length || 0)}"
        pos += last_packet_size
        sub_packets = bits[pos..-1]
      end
      # puts "part 1 remainder #{sub_packets}"
    else
      raise "Invalid length_type_id #{length_type_id}"
    end
  end

  {version: version, packet_type: packet_type, packet_value: packet_value, remainder: bits[pos..-1]}
end

def sum_versions(packet)
  version = packet[:version]
  if packet[:packet_type] == 4
    version
  else
    version += packet[:packet_value].map{|p| sum_versions(p)}.sum
  end
end

def value(packet)
  case packet[:packet_type]
  when 0
    packet[:packet_value].map {|subp| value(subp)}.sum
  when 1
    packet[:packet_value].map {|subp| value(subp)}.reduce(:*)
  when 2
    packet[:packet_value].map {|subp| value(subp)}.min
  when 3
    packet[:packet_value].map {|subp| value(subp)}.max
  when 4
    packet[:packet_value]
  when 5
    value(packet[:packet_value][0]) > value(packet[:packet_value][1]) ? 1 : 0
  when 6
    value(packet[:packet_value][0]) < value(packet[:packet_value][1]) ? 1 : 0
  when 7
    value(packet[:packet_value][0]) == value(packet[:packet_value][1]) ? 1 : 0
  else
    raise "Invalid packet type #{packet[:packet_type]}"
  end
end

# puts next_packet(bits)

# data = '8A004A801A8002F478'
# bits = data.chars.map {|c| HEXA[c]}.join
# puts sum_versions(next_packet(bits)) == 16

# data = '620080001611562C8802118E34'
# bits = data.chars.map {|c| HEXA[c]}.join
# # puts next_packet(bits)
# # puts sum_versions(next_packet(bits))
# puts sum_versions(next_packet(bits)) == 12

# data = 'C0015000016115A2E0802F182340'
# bits = data.chars.map {|c| HEXA[c]}.join
# puts sum_versions(next_packet(bits)) == 23

# data = 'A0016C880162017C3686B18A3D4780'
# bits = data.chars.map {|c| HEXA[c]}.join
# puts sum_versions(next_packet(bits)) == 31

# data = File.read('day16.txt')
# # puts data
# bits = data.chars.map {|c| HEXA[c]}.join
# # puts bits
# puts sum_versions(next_packet(bits))
puts value(next_packet(File.read('day16.txt').chars.map {|c| HEXA[c]}.join))

