#!/usr/bin/env ruby
require "./corpus/predictor"

ngram_val = 2
predict = Predictor.new(ngram_val,:experiment)

unigrams = predict.get_unigrams
bigrams = predict.get_bigrams
trigrams = predict.get_trigrams
v_size = unigrams.flatten.uniq.size

#build a list of occurrences
# puts grams.inspect

number_of_occurrences_unigrams = Hash.new(0)
number_of_occurrences_bigrams = Hash.new(0)
number_of_occurrences_trigrams = Hash.new(0)

unigrams.each do |gram|
  number_of_occurrences_unigrams[gram] += 1
end

bigrams.each do |gram|
  number_of_occurrences_bigrams[gram] += 1
end

trigrams.each do |gram|
  number_of_occurrences_trigrams[gram] += 1
end

puts "DONE WITH COUNTING!"

# Save vocabulary size in unigrams
File.open("v_size.txt", "w+") do |f|
  f.puts(v_size)
end

# Save UNIGRAMS to file
File.open("unigrams.txt", "w+") do |f|
  number_of_occurrences_unigrams.each do |words, occurences| 
    f.puts((words << occurences).join(" "))
    STDOUT.flush
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
