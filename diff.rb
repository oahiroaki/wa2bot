module Wa2Bot
  module Diff
    module_function

    # Reference: http://www.bookoff.co.jp/files/ir_pr/6c/np_diff.pdf
    def calc_edit_distance(str1, str2)
      # setup
      if str1.length <= str2.length
        a, b = str1, str2
      else
        a, b = str2, str1
      end
      m, n = a.length, b.length
      delta = n - m

      # snake
      snake = lambda do |k, y|
        x = y - k
        while x < m and y < n and a[x + 1] == b[y + 1] do
          x += 1
          y += 1
        end
        return y
      end

      offset = m + 1
      fp = Array.new(m + n + 3, -1)
      p = -1

      # main routine
      until fp[delta + offset] == n do
        p += 1

        (-p).upto(delta - 1) do |k|
          fp[k + offset] = snake.call(k, [
            fp[k - 1 + offset] + 1,
            fp[k + 1 + offset]
          ].max)
        end

        (delta + p).downto(delta + 1) do |k|
          fp[k + offset] = snake.call(k, [
            fp[k - 1 + offset] + 1,
            fp[k + 1 + offset]
          ].max)
        end

        fp[delta + offset] = snake.call(delta, [
          fp[delta - 1 + offset] + 1,
          fp[delta + 1 + offset]
        ].max)
      end

      return delta + 2 * p
    end
  end
end
