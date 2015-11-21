

if __FILE__ == $0
 load 'regex'  # The filename holding your Regex class
end

inputname = "c:/vagrantdev/input2"

stats = Regex.new('coloradomesa.edu')
File.open(inputname, "r") do |f|
  f.each_line do |x|
    stats.parse_line(x)
  end
end

h = stats.results

key2title = { "sent" =>      "senders",
              "received" =>  "receivers",
              "discarded" => "spammed",
              "seen" =>      "seen",
            }

key2title.each_key do |k|
  puts "Top #{key2title[k]}:"
  sorted = h.sort {|a,b| (b[1][k] <=> a[1][k]).nonzero? || (a[0] <=> b[0]) }
  top3 = sorted.first(1000)
  nonzero = top3.select{|x| x[1][k] > 0 }
  nonzero.each { |x| printf "  %s: %d\n", x[0], x[1][k] }
  end