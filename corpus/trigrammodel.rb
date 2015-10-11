
class Trigrammodel
  attr_accessor :unigrams
  attr_accessor :bigrams
  attr_accessor :trigrams
  attr_accessor :v_size

  def initialize(v, unigrams, bigrams, trigrams)
    @v_size = v
    @unigrams = unigrams
    @bigrams = bigrams
    @trigrams = trigrams
  end

  # This method uses backtracking if no trigrams could be found
  def most_probable_next_word(string)
    words = string.split(" ")
    bigram_key = words.last
    trigram_key = words.last(2).join(" ") if words.count >= 2
    most_probable_word = ""

    ## if we can find trigram and trigram exists
    if words.count >= 2 and @trigrams[trigram_key] != nil
      # get w3 from grams with highest P(w1,w2,w3) = P(w1)*P(w2|w1)*P(w3|w1,w2)
      highest_probability = 0.0

      @trigrams[trigram_key].each_key do |word|
        # puts "BIGRAMS WORDS: " + trigram_key + " " + word
        tempProb = probability_of_sequence(trigram_key + " " + word)
        # if P(w1)*P(w2|w1)*P(w3|w1,w2) > highest_probability
        if tempProb > highest_probability
          highest_probability = tempProb
          most_probable_word = word
        end
      end

      puts "ERROR IN TRIGRAMS" if highest_probability == 0.0
      return most_probable_word
    ## if we can find a bigram and bigram exists
    elsif words.count >= 1 and @bigrams[bigram_key] != nil
      # get w2 from grams with highest P(w2|w1)
      highest_probability = 0.0

      @bigrams[bigram_key].each_key do |word|
        tempProb = probability_of_sequence(bigram_key + " " + word)
        # if P(w1)*P(w2|w1) > highest_probability
        if tempProb > highest_probability
          highest_probability = tempProb
          most_probable_word = word
        end
      end
      puts "ERROR IN BIGRAMS" if highest_probability == 0.0
      return most_probable_word
    ## return random unigram?
    else
      return "FAIL"
    end
  end

  def probability_of_sequence(sequence)
    words = sequence.split(" ")
    if words == ""
      return 0.0
    end

    unigram_word = words.last if words.count >= 1
    bigram_words = words.last(2) if words.count >= 2
    trigram_words = words.last(3) if words.count >= 3
    
    if words.count >= 3 and @trigrams[trigram_words[0] + " " + trigram_words[1]] != nil
      # P(w3|w1,w2) = c(w1,w2,w3)/c(w1,w2)
      w1w2w3 = @trigrams[trigram_words[0] + " " + trigram_words[1]][trigram_words[2]].to_f
      w1w2 = @bigrams[trigram_words[0]][trigram_words[1]].to_f
      tempProb = (w1w2w3/w1w2)
      # P(w3|w1,w2) * (P(w1)*P(w2|w1))
      # puts "w1 w2: " + trigram_words[0] + " " + trigram_words[1] + " tempProb: " + tempProb.to_s
      return (tempProb*probability_of_sequence(trigram_words[0] + " " + trigram_words[1]))
    elsif words.count >= 2 and @bigrams[bigram_words] != nil
      # P(w2|w1) = c(w1,w2)/c(w1)
      w1w2 = @bigrams[bigram_words[0]][bigram_words[1]]
      w1 = @unigrams[bigram_words[0]]
      tempProb = (w1w2/w1)
      # P(w2|w1) * (P(w1))
      return (tempProb*probability_of_sequence(bigram_words[0]))
    else
      # P(w1) = c(w1)/V
      # puts "word: " + unigram_word.to_s + " c(word):" + @unigrams[unigram_word].to_s + " size: " + @v_size.to_s + " c(word)/size: " + (@unigrams[unigram_word]/@v_size.to_f).to_s
      return (@unigrams[unigram_word]/@v_size.to_f)
    end

  end
  
end
