$grid = ARGF.readlines(chomp:true).map(&:chars)


def valid?(a,b)
  b != '.' && (a.to_i+1) == (b.to_i)
end
def find_path(i,j)
  cell = $grid[i][j].to_i
  return [[i,j]] if cell == 9

  sum = []

  [[0,1], [1,0], [-1,0], [0,-1]].each do |(a,b)|
    next if i+a < 0 || j+b < 0
    if valid?(cell, $grid.dig(i+a,j+b))
      # puts "[#{i},#{j}]#{cell}->[#{i+a},#{j+b}]#{$grid.dig(i+a,j+b)}"
      sum += find_path(i+a,j+b)
    end
  end

  sum
end

total = 0

$grid.each.with_index do |line, i|
  line.each.with_index do |cell,j|
    if cell == '0'
      score = find_path(i,j).count
      # puts "score: #{score}"
      total += score
    end
  end
end

puts total
