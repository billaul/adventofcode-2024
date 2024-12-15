A = 3
B = 1

X = 0
Y = 1
TOKENS = 2

lines   = ARGF.readlines(chomp:true)

total_tokens = 0
lines.each_slice(4) do |lines|
  puts
  puts lines[0]
  puts lines[1]
  puts lines[2]
  x = (lines[0].scan(/\d+/).map &:to_i) << A
  y = (lines[1].scan(/\d+/).map &:to_i) << B
  prize = lines[2].scan(/\d+/).map &:to_i

  prize[0] += 10000000000000
  prize[1] += 10000000000000

  a = {a: x[0], b: y[0], sum: prize[0]}
  b = {a: x[1], b: y[1], sum: prize[1]}

  lcm = a[:b].lcm(b[:b])
  a = {a: a[:a] * lcm, b: a[:b] * lcm, sum: a[:sum] * lcm}

  cmm = a[:b] / b[:b]
  b = {a: b[:a] * cmm, b: b[:b] * cmm, sum: b[:sum] * cmm}

  a[:a] -= b[:a]
  a[:b] -= b[:b] # => REMAIN 0
  a[:sum] -= b[:sum]

  a = a[:sum] / a[:a]
  b = (b[:sum] - (b[:a] * a)) / b[:b]

  # puts "A: #{a} B: #{b}"
  # puts "[#{a*x[0] + b*y[0]},#{a*x[1] + b*y[1]}]"

  if a*x[0] + b*y[0] == prize[0] && a*x[1] + b*y[1] == prize[1]
#     puts "A: #{a} B: #{b}"
    total_tokens += a * 3 + b
  end
end
puts total_tokens
