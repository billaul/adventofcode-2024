@grid = STDIN.read.split("\n").map{_1.each_char.to_a}

@count = 0

def search(i,j, a,b, src)
  return if i+a < 0 || j+b < 0 || (a.zero? && b.zero?)

  if @grid.dig(i+a,j+b) == src[0]
    if src.length == 1
      @count += 1
    else
      search(i+a,j+b, a,b, src[1..-1])
    end
  end
end

@grid.each.with_index do |line, i|
  line.each.with_index do |char, j|
    if char == 'X'
      [-1,-1,0,1,1].permutation(2).to_a.uniq.each do |a,b|
        search(i,j, a,b, 'MAS')
      end
    end
  end
end

puts @count
