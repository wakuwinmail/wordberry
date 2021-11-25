# coding: utf-8
require 'natto'

natto = Natto::MeCab.new

#input.in (text)
#output.out (information of word tree)
output = File.open("output.out", "w")

File.open("input.in", "r:utf-8") do |file|
    file.each_line do |words|
        natto.parse(words) do |word|
            output.puts (word.surface)
        end
    end
end