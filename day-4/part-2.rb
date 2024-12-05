@grid = ARGF.readlines(chomp:true).map(&:chars)


@count = 0
@grid.each.with_index do |line, i|
  line.each.with_index do |char, j|
    if char == 'A'
      @cross = "#{@grid.dig(i+1,j+1)}#{@grid.dig(i+1,j-1)}#{@grid.dig(i-1,j-1)}#{@grid.dig(i-1,j+1)}"
      @count += 1 if %w[MMSS MSSM SSMM SMMS].include?(@cross)
    end
  end
end

puts @count
