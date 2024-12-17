puts STDIN.read.split("\n")
    .map{_1.split(/\s+/).map(&:to_i)}
    .transpose
    .tap {|ar| ar[0].map! {|v| (v * ar[1].count(v)) } }
    .first.sum
