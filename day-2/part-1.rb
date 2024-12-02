puts(STDIN.read.split("\n")
          .map { _1.split(' ').map(&:to_i) }
          .map! {
            _1.instance_eval { (sort == self || sort.reverse == self) && each_cons(2).all? { |a| a[0] != a[1] && a.reduce(&:-).abs <= 3 } }
          }.count{ _1 })
