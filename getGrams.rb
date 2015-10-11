#!/usr/bin/env ruby
require "./corpus/predictor"

ngram_val = 2
predict = Predictor.new(ngram_val,:experiment)

# Get all unique unigrams
unigrams = predict.get_unigrams.flatten.uniq

bigrams = predict.get_bigrams
trigrams = predict.get_trigrams


#build a list of occurrences
# puts grams.inspect

number_of_occurrences_bigrams = Hash.new(0)
number_of_occurrences_trigrams = Hash.new(0)

bigrams.each do |gram|
  number_of_occurrences_bigrams[gram] += 1
end

trigrams.each do |gram|
  number_of_occurrences_trigrams[gram] += 1
end

puts "DONE WITH COUNTING!"

# Save UNIGRAMS to file
File.open("unigrams.txt", "w+") do |f|
  unigrams.each do |word|
    f.puts(word)
  end
end

# Save BIGRAMS and their frequency to file
File.open("bigrams.txt", "w+") do |f|
  number_of_occurrences_bigrams.each do |words, occurences| 
    f.puts((words << occurences).join(" "))
    STDOUT.flush
  end
end

# puts number_of_occurrences_trigrams.inspect

# Save TRIGRAMS and their frequency to file
File.open("trigrams.txt", "w+") do |f|
  number_of_occurrences_trigrams.each do |words, occurences| 
    f.puts((words << occurences).join(" "))
    STDOUT.flush
  end
end

# puts unigrams.inspect

puts "DONE WITH SAVING"
