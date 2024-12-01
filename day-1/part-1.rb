puts STDIN.read.split("\n")
    .map{_1.split(/\s+/).map(&:to_i)}
    .transpose.map(&:sort)
    .tap {|ar| ar[0].map!.with_index {|v, i| (v - ar[1][i]).abs } }
    .first.sum
