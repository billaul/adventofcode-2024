A = 3
B = 1

X = 0
Y = 1
TOKENS = 2

lines   = ARGF.readlines(chomp:true)

def pres(bts, prize)
  x = prize[X]
  y = prize[Y]

  bt_1, bt_2 = bts

  if bt_2 != nil
    puts "---------------"
    bt_1_count_x = (x / bt_1[X]).floor
    bt_1_count_y = (y / bt_1[Y]).floor

    puts "bt_1 #{bt_1} / bt_2 #{bt_2} / prize:#{prize}"
    puts "bt_1_count_x:#{bt_1_count_x}"
    puts "var #{[x - bt_1[X] * bt_1_count_x, y - bt_1[Y] * bt_1_count_x]}"

    var_1 = pres([bt_2],[x - bt_1[X] * bt_1_count_x, y - bt_1[Y] * bt_1_count_x])
    var_1 += (bt_1_count_x * bt_1[TOKENS]) if var_1

    puts "bt_1_count_y:#{bt_1_count_y}"

    puts "-x:#{bt_1[X] * bt_1_count_y}"
    puts "var #{[x - bt_1[X] * bt_1_count_y, y - bt_1[Y] * bt_1_count_y]}"

    var_2 = pres([bt_2],[x - bt_1[X] * bt_1_count_y, y - bt_1[Y] * bt_1_count_y])
    var_2 + (bt_1_count_y * bt_1[TOKENS]) if var_2

    puts "a:#{var_1} b:#{var_2}"

    [var_1, var_2].compact.min
  else
    puts "x,y: [#{x},#{y}] / #{x % bt_1[X]} "
    return if x < 0 || y < 0 || (x % bt_1[X]) != 0
    x / bt_1[X] * bt_2[TOKENS]
  end
end



total_tokens = 0
lines.each_slice(4) do |lines|
  bt_a = (lines[0].scan(/\d+/).map &:to_i) << A
  bt_b = (lines[1].scan(/\d+/).map &:to_i) << B
  prize = lines[2].scan(/\d+/).map &:to_i

  puts "#{prize.to_s}"
  tokens = []
  100.times do |a|
    100.times do |b|
      x = a * bt_a[X] + b * bt_b[X]
      y = a * bt_a[Y] + b * bt_b[Y]
      tokens << a * A + b * B if prize == [x,y]
    end
  end
  total_tokens += tokens.min unless tokens.empty?
end
puts total_tokens
