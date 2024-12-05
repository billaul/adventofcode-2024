lines = ARGF.readlines(chomp:true)

def valid?(pages)
  pages.each.with_index do |page, index|
    next if index.zero?

    prev_page = pages[index - 1]
    return false unless @rules[prev_page]&.include?(page)
  end
  true
end

listes = []
@rules = {}
lines.each do |line|
  if line['|']
    a,b = line.split('|')
    @rules[a] ||= []
    @rules[a] << b
  elsif line[',']
    line = line.split(',')
    listes << line if valid?(line)
  end
end
puts listes.map { _1[_1.length/2].to_i  }.sum
