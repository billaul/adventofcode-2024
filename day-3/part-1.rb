puts(STDIN.read.scan( /mul\((\d+,\d+)\)/ ).flatten.map{ _1.split(',').map(&:to_i).reduce(&:*) }.sum )
