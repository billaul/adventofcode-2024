puts(STDIN.read.split("\n")
          .map { _1.split(' ').map(&:to_i) }
          .map! do |ar|
            (ar.instance_eval { (sort == self || sort.reverse == self) && each_cons(2).all? { |a| a[0] != a[1] && a.reduce(&:-).abs <= 3 } }) ||
            ar.length.times.find do |i|
              ar.each_with_index.reject { |_, n| n == i }.map(&:first)
                .instance_eval { (sort == self || sort.reverse == self) && each_cons(2).all? { |a| a[0] != a[1] && a.reduce(&:-).abs <= 3 } }
            end
          end.count { _1 })
