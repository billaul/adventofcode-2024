puts("do()#{STDIN.read}".scan(
  /mul\((\d+,\d+)\)|(don't\(\))|(do\(\))/
).flatten.compact.map{
  _1['do()'] .. _1["don't()"] ? (_1['do'] ? 0 : _1.split(',').map(&:to_i).reduce(&:*)) : 0
}.sum )
