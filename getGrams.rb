#!/usr/bin/env ruby
require_relative 'corpus/corpusreader'

ngram_type = :mystery # Change this to the desired corpus
predict = Corpusreader.new(ngram_type)
puts ngram_type.to_s

unigrams = predict.get_unigrams
bigrams = predict.get_bigrams
trigrams = predict.get_trigrams
v_size = unigrams.flatten.uniq.size

#build a list of occurrences
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

# Save TRIGRAMS and their frequency to file
File.open("trigrams.txt", "w+") do |f|
  number_of_occurrences_trigrams.each do |words, occurences| 
    f.puts((words << occurences).join(" "))
    STDOUT.flush
  end
end

puts "DONE WITH SAVING"
