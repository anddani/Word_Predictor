#!/usr/bin/env ruby
require "./corpus/predictor"

ngram_val = 2
predict = Predictor.new(ngram_val,:experiment)

grams = predict.get_trigrams

# Get all unique unigrams
unigrams = predict.get_unigrams.flatten.uniq

#build a list of occurrences
# puts grams.inspect

number_of_occurrences = Hash.new(0)

grams.each do |gram|
  number_of_occurrences[gram] += 1
end

puts "DONE WITH COUNTING!"
puts number_of_occurrences.inspect

File.open("model.txt", "w+") do |f|
  number_of_occurrences.each do |words, occurences| 
    f.puts((words << occurences).join(" "))
    STDOUT.flush
  end
end

# puts unigrams.inspect

File.open("unigrams.txt", "w+") do |f|
  unigrams.each do |word|
    f.puts(word)
  end
end

puts "DONE WITH SAVING"
