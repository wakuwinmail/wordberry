require 'yaml'
require './load_data.rb'

config = YAML.load_file("config.yml")
file_names = config["file_name"]

#既存データの読み込み
bow = load_bow(file_names["bag_of_words"])
mat = load_matrix(file_names["adjacency_matrix"])

n = bow.size
#累積和の配列を作る
#将来的には値を変更(1点更新)できるようにしたい(BITやSegment Tree)
ruis = Array.new
n.times do |i|
  ruis.append(Array.new)
  ruis[i][0] = mat[i][0]
  for j in 1...n do
    ruis[i][j] = ruis[i][j-1]+mat[i][j]
  end
end

w = "" #開始は空文字
res = "" #結果



while res.size<140 do
  break if res.size + w.size >140
  res += w
  ind = bow[w]
  val = rand(0.0..ruis[ind][n-1])
  nind = ruis[ind].bsearch_index {|x| x>= val}
  break if nind == 0
  w = bow.rassoc(nind)[0]
end
puts res