require 'corpus/predictor'

ngram_val = 2
predict = Predictor.new(ngram_val,:fiction)

grams = predict.get_trigrams

#build a list of occurrences
puts grams.inspect

number_of_occurrences = Hash.new(0)

grams.each do |gram|
  number_of_occurrences[gram] += 1
end

# remaining = grams
# result = []
#
# grams.each do |gram|
#   number_of_occurrences = 0
#   remaining.each do |rem|
#     if gram == rem
#       number_of_occurrences += 1
#     end
#   end
#   result += [gram + [number_of_occurrences]]
#   remaining.delete(gram)
# end
puts "DONE WITH COUNTING!"

# sorted = result.sort_by {|elem| elem[ngram_val]}.reverse
# puts "DONE WITH SORTING!"
# puts sorted.inspect

# File.open("model.txt", "w+") do |f|
#   sorted.each { |first| 
#     first.each { |second| 
#       f.print(second.to_s + " ")
#       STDOUT.flush
#     }
#     f.puts("")
#   }
# end

File.open("model.txt", "w+") do |f|
  number_of_occurrences.each do |words, occurences| 
    f.puts((words << occurences).join(" "))
    STDOUT.flush
  end
end

puts "DONE WITH SAVING"
