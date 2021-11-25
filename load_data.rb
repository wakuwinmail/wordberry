# coding: utf-8
def load_data(bow_fn, mat_fn)
  wtoi = Hash.new
  itow = Hash.new
  ind = 0
  File.open("bow.in", "r:utf-8") do |file|
    file.each_line do |word|
      wtoi[word.chomp] = ind
      itow[ind] = word.chomp
      ind = ind+1
    end
  end
  return [wtio, itow]
end