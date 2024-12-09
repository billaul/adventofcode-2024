lines = ARGF.readlines(chomp:true).map(&:chars)
# # puts lines[0].to_s

def save(str)
  File.write('output', "#{str}\n", mode: 'w+')
end

file = -1
disk = []
lines[0].map.with_index do |nbr, index|
  if index.even?

    file = file + 1
    disk << nbr.to_i.times.map { file }
  else
    disk << nbr.to_i.times.map { '.' }
  end
end
disk = disk.flatten

def find_space(disk, search)
  mem = 0
  disk.each_with_index do |c, i|
    if mem == search
      return i - search
    elsif c == '.'
      mem += 1
    else
      mem = 0
    end
  end
  nil
end

file = disk.last
moved = 0
not_moved = 0

while file > 0
  print "\rmoved: #{moved}/not_moved: #{not_moved} | #{file}"
  # puts disk.join ''

  fi  = disk.index(file)
  fri = disk.rindex(file)
  f_size = fri - fi + 1

  # ptin "file:#{file}/#{f_size}"
  index = find_space(disk, f_size)
  if index && index < fi
    disk[index ... index + f_size] = disk[fi ... fi + f_size]
    disk[fi ... fi + f_size] = ['.'] * f_size
    # puts disk.join ''
    moved+= 1
  else
    not_moved += 1
  end

  file -= 1
end

# puts disk.join ''
total = 0
disk.each.with_index do|id, index|
  next 0 if id == 0 || id == '.'
  total += id * index
end
puts
puts total

# Should be
# ???
# too high
# 16488291456470
# 6488291456470
