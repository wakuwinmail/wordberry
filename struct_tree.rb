# coding: utf-8
require 'natto'
require 'yaml'
require 'date'
require './load_data.rb'

config = YAML.load_file("config.yml")
natto = Natto::MeCab.new
backup_active = false

#input.in (text)
#output.out (information of word tree)
file_names = config["file_name"]

#backupフォルダにコピー
if backup_active then
  now = DateTime.now
  dir_name = now.strftime("%Y-%m-%d")
  file_name = now.strftime("%H%M%S")

  backup_dir_name = "./#{config[dir_name][backup]}/#{dir_name}"
  Dir::mkdir(backup_dir_name) if !Dir::exist?(backup_dir_name)

  FileUtils.cp(file_names[bag_of_words],"#{backup_dir_name}/#{file_name+"_"+file_names[bag_of_words]}")
  FileUtils.cp(file_names[adjacency_matrix],"#{backup_dir_name}/#{file_name+"_"+file_names[adjacency_matrix]}")
end

#既存データの読み込み
bow = load_bow(file_names["bag_of_words"])
mat = load_matrix(file_names["adjacency_matrix"])

pw = ""

File.open(file_names["raw_text"], "r:utf-8") do |file|
  file.each_line do |sentence|
    sentence.chomp!
    next if sentence.size==0
    natto.parse(sentence.chomp) do |n|
      w = n.surface
      if !bow.key?(w) then #いま見てる単語がbowになければ追加
        bow[w] = bow.size
        mat.append(Array.new)
      end

      if mat[bow.assoc(pw)[1]][bow.assoc(w)[1]]==nil then
        mat[bow.assoc(pw)[1]][bow.assoc(w)[1]]=0
      end
      mat[bow.assoc(pw)[1]][bow.assoc(w)[1]] += 1
      pw = w
    end
  end
end

#bowと隣接行列のファイルを更新
n = bow.size

File.open(file_names["bag_of_words"], "w:utf-8") do |file|
  n.times do |i|
    file.puts(bow.rassoc(i)[0])
  end
end

File.open(file_names["adjacency_matrix"], "w:utf-8") do |file|
  n.times do |i|
    n.times do |j|
      if mat[i][j]==nil then
        mat[i][j] = 0
      end
      file.print mat[i][j]
      file.print " " if j<n-1
    end
    file.print ("\n")
  end
end