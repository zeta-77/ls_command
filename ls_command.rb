# frozen_string_literal: true

require_relative 'normal_display'
require_relative 'detail_display'
require 'pathname'
require 'date'
require 'optparse'

# ■■■コマンドライン引数の取得■■■
# コマンドの書式：ls [オプション] [ディレクトリ]
opt = OptionParser.new
opt_a, opt_l, opt_r = opt.getopts('alr').values_at('a', 'l', 'r')

# ■■■パスの取得■■■
opt.on('*')
arg_temp = opt.parse(ARGV)
path_temp = '.'
# ディレクトリを取得する　⇨　ディレクトリ指定なしの場合はカレントディレクトをデフォルト指定
path_temp = arg_temp[0] unless arg_temp[0].nil?
path_obj = Pathname.new(path_temp)

# 存在しないパスが指定されている時は、エラーMSGを表示してプログラムを終了する
unless path_obj.exist?
  puts "ls: #{path_temp}: No such file or directory"
  exit # プログラム終了
end
path = path_obj.expand_path # 絶対パスを取得

# ■■■ファイル群取得＆ソート■■■
Dir.chdir(path) # Dirクラスにpathを指定する
file_arr = if opt_a
             Dir.glob('*', File::FNM_DOTMATCH).sort # ファイル名、隠しファイル名、ディレクトリ名を取得
           else
             Dir.glob('*').sort # ファイル名とディレクトリ名を取得(隠しファイル非表示)
           end
# 「-r」の指定があれば逆ソートする
file_arr = file_arr.reverse if opt_r

# ■■■ディレクトリ部分取得■■■
dir = if path.directory?
        path.to_s
      else # 絶対パスがファイルだった場合
        path.dirname.to_s
      end

# ■■■表示処理■■■
if opt_l # 詳細表示指定の場合
  detail_display = DetailDisplay.new(dir, file_arr)
  detail_display.display
else # 標準表示指定の場合
  normal_display = NormalDisplay.new(dir, file_arr)
  normal_display.display
end
