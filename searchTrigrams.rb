#!/usr/bin/env ruby

gramTable = Hash.new()
File.open("trigrams.txt", "r") do |f|
  while (line = f.gets)
    line = line.split(" ")
    # puts "line: " + line.inspect
    val = {line[2] => line[3].to_i}
    # puts "val: " + val.inspect
    # gramTable.merge!(line[0] + " " + line[1] => val)
    # gramTable.store(line[0] + " " + line[1], val)
    key = line[0] + " " + line[1]
    gramTable[key] ||= {}
    gramTable[key] = val.merge!(gramTable[key])
    # puts "hash: " + gramTable.inspect
  end
end

unigrams = {}
File.open("unigrams.txt", "r") do |f|
  while (line = f.gets) do
    line.delete!("\n")
    unigrams[line] = 0
  end
  # Insert in trigrams hash
  # while (line = f.gets)
  #   line.delete!("\n")
  #   gramTable.each_key do |k|
  #     if gramTable[k][line] == nil
  #       val = {line => 0}
  #       gramTable[k] = val.merge!(gramTable[k])
  #     end
  #   end
  # end
end

puts gramTable.inspect
puts unigrams.inspect

puts "TESTCASE gramtable['I am']['glad']: " + gramTable['I am']['glad'].to_s
puts "TESTCASE gramtable['I am']['sad']: " + gramTable['I am']['sad'].to_s
# puts "TESTCASE gramtable['I try']['often']: " + gramTable['I try']['often'].to_s
puts "TESTING" if gramTable['I try'] == nil

# print "->"
# while sentence = gets().delete("\n") != "exit" do
#
# print "->"
# puts sentence
# end
