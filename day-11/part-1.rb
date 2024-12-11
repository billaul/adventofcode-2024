stones = ARGF.readlines(chomp:true)[0].split(' ').map &:to_i

25.times do |i|
  puts "#{i+1}/#{stones.count}"
  # puts "#{stones.to_s}"
  stones = stones.flat_map do |nbr|
    if nbr == 0
      1
    elsif (Math.log10(nbr).floor + 1).even?
      nbr = nbr.to_s
      [nbr[... nbr.length/2].to_i,nbr[nbr.length/2 .. ].to_i]
    else
      nbr * 2024
    end
  end
end

puts stones.count
