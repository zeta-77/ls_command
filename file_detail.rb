# frozen_string_literal: true

require 'etc'

# ファイル詳細クラス
class FileDetail
  attr_reader :permission
  attr_reader :hardlink
  attr_reader :user
  attr_reader :group
  attr_reader :size
  attr_reader :time

  def initialize(arg_directory, arg_file)
    @directory = arg_directory
    @file = arg_file
    @directory_file = @directory + '/' + @file
    @file_lstat = File.lstat(@directory_file)
    @permission = make_permission_chars
    @hardlink = @file_lstat.nlink
    @user = Etc.getpwuid(@file_lstat.uid).name
    @group = Etc.getgrgid(@file_lstat.gid).name
    @size = @file_lstat.size
    @time = make_date_time_chars
  end

  def make_permission_chars
    # ■■■ノードの種類■■■
    # 「ls -l」　d：ディレクトリ　l：シンボリックリンク　-：通常のファイル

    # ■■■権限の取得■■■
    # ユーザの権限、グループの権限、他人の権限
    permission_temp = File.lstat(@directory_file).mode.to_s(8)
    permission_chars = permission_temp.rjust(6, '0') # 0埋め6桁表示
    file_kind = permission_chars.slice(0, 3) # ファイル種別
    permission_u = permission_chars.slice(3, 1) # ユーザ権限
    permission_g = permission_chars.slice(4, 1) # グループ権限
    permission_o = permission_chars.slice(5, 1) # 他人権限

    convert_chars(file_kind, permission_u, permission_g, permission_o)
  end

  def convert_chars(file_kind, permission_u, permission_g, permission_o)
    # ■■■表示■■■
    { '100' => '-', '040' => 'd', '120' => 'l' }.each do |key, value|
      file_kind = file_kind.gsub(key, value)
    end
    # 権限の数値を表示用文字列に置換する
    { '0' => '---', '1' => '--x', '2' => '-w-', \
      '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.each do |k, v|
      permission_u = permission_u.gsub(k, v)
      permission_g = permission_g.gsub(k, v)
      permission_o = permission_o.gsub(k, v)
    end
    file_kind + permission_u + permission_g + permission_o
  end

  # 日時の取得
  def make_date_time_chars
    month = @file_lstat.mtime.strftime('%m').to_i.to_s
    date = @file_lstat.mtime.strftime('%d').to_i.to_s
    time = @file_lstat.mtime.strftime('%R')
    month.rjust(2, ' ') + ' ' + date.rjust(2, ' ') + ' ' + time
  end
end
