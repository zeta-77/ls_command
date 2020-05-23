# frozen_string_literal: true

require_relative 'file_detail'
require_relative 'line_maker'

# 【詳細表示クラス】
class DetailDisplay
  attr_reader :directory
  attr_reader :files

  def initialize(arg_directory, arg_files)
    @directory = arg_directory
    @files = arg_files
  end

  # 表示処理実行
  def display
    row = 0
    total_blocks = 0
    matrix = Array.new(files.size).map { Array.new(7, '') }
    files.each do |f|
      detail = FileDetail.new(@directory, f)
      # 2次元配列に格納する
      matrix[row][0] = detail.permission + '  '
      matrix[row][1] = detail.hardlink.to_s + ' '
      matrix[row][2] = detail.user + '  '
      matrix[row][3] = detail.group + '  '
      matrix[row][4] = detail.size.to_s + ' '
      matrix[row][5] = detail.time + ' '
      matrix[row][6] = f
      row += 1
      total_blocks += File::Stat.new(@directory + '/' + f).blocks
    end
    puts "total " + total_blocks.to_s
    # 行データ作成クラスLineMakerに２次元配列を渡す
    LineMaker.new(matrix).line_arr.each { |line| puts line }
  end
end
