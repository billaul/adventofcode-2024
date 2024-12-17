lines = ARGF.readlines(chomp:true).map(&:chars)
# puts lines[0].to_s

file = -1
disk = []
lines[0].map.with_index do |nbr, index|
  # puts "#{file}/#{nbr}/#{index}"
  if index.even?

    file = file + 1
    disk << nbr.to_i.times.map { file }
  else
    disk << nbr.to_i.times.map { '.' }
  end
end
disk = disk.flatten

total_space = disk.count('.')
to_take = disk[0...-total_space]
to_move = disk[-total_space..-1].select{_1 != '.'}

# while !to_move.empty?
#   to_take[to_take.index('.')] = to_move.pop
#   # print "\r#{to_take.count('.')}     "
# end

puts 'ziped'

to_take.map! do
  if _1 != '.'
    _1
  else
    to_move.pop
  end
  # print "\r#{to_take.count('.')} "
end

total = 0
# puts disk
 to_take.each.with_index do|id, index|
  next 0 if id == 0
  total += id * index
end
puts total

# Should be
# 6461289671426
# too high
# 22739494946452
# too low
# 5684363686

total = 0
'00992111777.44.333....5555.6666.....8888..'.split('').each.with_index do|id, index|
  total += id.to_i * index
end
puts total
