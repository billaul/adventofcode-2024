puts(STDIN.read.split("\n")
          .map { _1.split(' ').map(&:to_i) }
          .map! {
            (_1.sort == _1 || _1.sort.reverse == _1) && _1.each_cons(2).all? { |a| a[0] != a[1] && a.reduce(&:-).abs <= 3 }
          }.count{ _1 })
