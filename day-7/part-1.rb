lines = ARGF.readlines(chomp:true)
count = 0
lines.each do |line|
  nbr, nbrs = line.split(': ')

  length = (nbrs.split(' ').length) - 1
  combine = (%w[+ *] * length).combination(length).to_a.uniq

  combine.each do |operators|
    calc = nbrs.dup.split(' ').map(&:to_i)

    calc = calc.reduce do |a, b|
      case operators.pop
      when '+'
        a+b
      when '*'
        a*b
      end
    end

    if nbr.to_i == calc
      puts line
      count += nbr.to_i
      break
    end
  end

end

puts count
