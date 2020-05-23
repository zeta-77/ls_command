# frozen_string_literal: true

# 詳細表示行を作成するクラス
class LineMaker
  attr_reader :line_arr

  # ２次元配列を引数で取得する
  def initialize(arr_arg)
    col_num = 0
    width = []
    # 各列の幅を計算する
    arr_arg.transpose.each do |col| # 7列分の処理
      width[col_num] = 0
      col.each { |row| width[col_num] = row.size if width[col_num] < row.size }
      col_num += 1
    end

    # 行データの作成処理
    make_line(arr_arg, width)
  end

  # 行データ作成メソッド
  def make_line(arr_arg, width)
    @line_arr = []
    arr_arg.each do |x|
      @line_arr.push(x[0].ljust(width[0]) + x[1].rjust(width[1]) + \
                     x[2].ljust(width[2]) + x[3].ljust(width[3]) + \
                     x[4].rjust(width[4]) + x[5].ljust(width[5]) + \
                     x[6].ljust(width[6]))
    end
  end
end
