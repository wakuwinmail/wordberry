require 'twitter'
require 'date'
require 'yaml'

config = YAML.load_file("config.yml")

client = Twitter::REST::Client.new(config)

now = DateTime.now
dir_name = now.strftime("%Y-%m-%d")
file_name = now.strftime("%H%M%S")

Dir::mkdir("#{dir_name}") if !Dir::exist?("#{dir_name}")
data=File.open("rawtext.txt","w:utf-8")#出力用ファイルを開く
ngwords=File.open("ngwords.txt","r:utf-8")#NGワードが書かれたファイルを開く
max_id = client.home_timeline.first.id

File.open("#{dir_name}/#{file_name}.txt","w:utf-8") do |file|#データベース用のファイルを開く
  1.times do
    #max_id:これに入ってるIDより前のツイートを取得
    client.search("min_retweets:10000 lang:ja -filter:links -filter:replies -filter:retweets -filter:images", result_type: "recent", max_id: max_id).take(20).each do |tweet|#200*15個のツイートを取得
      max_id = tweet.id
      flag=true
      #p tweet.text
      ngwords.each_line do |words|
        if /#{words.chomp}/ =~ tweet.text
          flag=false
          break
        end
      end
      next if !flag
      s = +tweet.text#解凍処理
      file.print(s)#日本語ならデータベースに追加
      file.puts("\n")
      data.print(s)#日本語なら出力用ファイルに追加
      data.puts("\n")
    end
  end
end
data.close
ngwords.close