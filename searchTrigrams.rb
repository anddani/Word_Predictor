#!/usr/bin/env ruby
require './corpus/trigrammodel'

v_size = 0
File.open("v_size.txt", "r") do |f|
  v_size = f.gets.to_i
end

puts "v_size: " + v_size.to_s

unigrams = Hash.new()
File.open("unigrams.txt", "r") do |f|
  while (line = f.gets)
    line = line.split(" ")
    key = line[0]
    unigrams[key] = line[1].to_i
  end
end

puts "DONE READING UNIGRAMS"

bigrams = Hash.new()
File.open("bigrams.txt", "r") do |f|
  while (line = f.gets)
    line = line.split(" ")
    val = {line[1] => line[2].to_i}
    key = line[0]
    bigrams[key] ||= {}
    bigrams[key] = val.merge!(bigrams[key])
  end
end

puts "DONE READING BIGRAMS"

trigrams = Hash.new()
File.open("trigrams.txt", "r") do |f|
  while (line = f.gets)
    line = line.split(" ")
    val = {line[2] => line[3].to_i}
    key = line[0] + " " + line[1]
    trigrams[key] ||= {}
    trigrams[key] = val.merge!(trigrams[key])
  end
end

puts "DONE READING TRIGRAMS"

# puts unigrams.inspect
# puts bigrams.inspect
# puts trigrams.inspect

# puts "TESTCASE gramtable['I am']['glad']: " + trigrams['I am']['glad'].to_s
# puts "TESTCASE gramtable['I am']['sad']: " + trigrams['I am']['sad'].to_s

model = Trigrammodel.new(v_size, unigrams, bigrams, trigrams)

# sen = "I am"
# result = model.most_probable_next_word(sen)
# puts "Most probable next word for " + sen + ": " + result + " With a probability of " + model.probability_of_sequence(sen + " " + result).to_s
#
# sen = "I can"
# result = model.most_probable_next_word(sen)
# puts "Most probable next word for " + sen + ": " + result + " With a probability of " + model.probability_of_sequence(sen + " " + result).to_s

sen = "You am"
result = model.most_probable_next_word(sen)
puts "Most probable next word for " + sen + ": " + result
sen = "I am"
result = model.most_probable_next_word(sen)
puts "Most probable next word for " + sen + ": " + result
sen = "I ."
result = model.most_probable_next_word(sen)
puts "Most probable next word for " + sen + ": " + result
sen = "Why try"
result = model.most_probable_next_word(sen)
puts "Most probable next word for " + sen + ": " + result
sen = "I try"
result = model.most_probable_next_word(sen)
puts "Most probable next word for " + sen + ": " + result

# print "->"
# while (sentence = gets().chomp) != "exit" do
#   result = model.most_probable_next_word(sentence)
#   prob = model.probability_of_sequence(sentence + " " + result)
#   puts sentence + " " + result
#   puts "With a probability of: " + prob.to_s
#   print "->"
# end
