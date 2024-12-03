puts(
  "do()#{STDIN.read.tr("\n",'').gsub("do()","don't()do()")}don't()"
    .scan(/(?:\G|\A|do\(\))(?:(?!do\(\)|don't\(\)).)*?\Kmul\((\d+,\d+)\)(?=(?:(?!do\(\)).)*don't\(\))/)
    .flatten.map{_1.split(',').map(&:to_i).reduce(&:*)}.sum
)
