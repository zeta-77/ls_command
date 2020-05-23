# frozen_string_literal: true

# 【標準表示クラス】
class NormalDisplay
  attr_reader :directory
  attr_reader :files

  def initialize(arg_directory, arg_files)
    @directory = arg_directory
    @files = arg_files
  end

  # 表示処理実行
  def display
    # ターミナル幅から表示列数を求める
    terminal_width = `tput cols` # ターミナルの幅を取得
    col_num = terminal_width.to_i / 32 # 表示列数算出: 1列は半角32文字
    row_num = files.length / col_num # １列の行数を算出：要素数÷列数
    row_num += 1 if files.length % col_num != 0 # あまりが出たら＋１行

    # 行列表示: 行列を入れ替えた配列を渡す
    display_matrix(make_matrix(row_num, col_num))
  end

  # 行列生成
  def make_matrix(row_num, col_num)
    # ファイルの配列を２次元配列に格納し、行列を入れ替える
    str = ''
    ary = Array.new(col_num).map { Array.new(row_num, '') }
    col = 0
    cnt = 0 # filesのカウント
    ary.each do |ary_row|
      ary_row.each do
        ary_row[col] = @files[cnt]
        cnt += 1
        col += 1
      end
      col = 0
    end
    ary.transpose
  end

  # 行列表示
  def display_matrix(ary)
    str = ''
    ary.each do |x|
      x.each do |y|
        str += y.ljust(32 - (y.bytesize - y.size)) unless y.nil?
      end
      puts str
      str = ''
    end
  end
end
