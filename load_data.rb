# coding: utf-8
def load_bow(bow_fn)
  wtoi = Hash.new
  itow = Hash.new
  ind = 0
  File.open(bow_fn, "r:utf-8") do |file|
    file.each_line do |word|
      wtoi[word.chomp] = ind
      itow[ind] = word.chomp
      ind = ind+1
    end
  end
  return [wtoi, itow]
end

def load_matrix(mtx_fn)
  mat = Array.new
  File.open(mtx_fn, "r:utf-8") do |file|
    file.each_line do |dat|
      mat.append(dat.chomp.split(" ").map(&:to_i))
    end
  end
  return mat
end