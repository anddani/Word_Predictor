
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
    
    if words.count >= 3
      # P(w3|w1,w2) = c*(w1,w2,w3)/c*(w1,w2)
      # w1w2w3 = @trigrams[trigram_words[0] + " " + trigram_words[1]][trigram_words[2]].to_f
      # w1w2 = @bigrams[trigram_words[0]][trigram_words[1]].to_f
      w1w2w3 = good_turing_count(trigram_words.join(" "))
      w1w2 = good_turing_count(trigram_words[0] + " " + trigram_words[1])
      tempProb = (w1w2w3/w1w2)
      # P(w3|w1,w2) * (P(w1)*P(w2|w1))
      return (tempProb*probability_of_sequence(trigram_words[0] + " " + trigram_words[1]))
    elsif words.count >= 2
      # P(w2|w1) = c*(w1,w2)/c*(w1)
      # w1w2 = @bigrams[bigram_words[0]][bigram_words[1]].to_f
      # w1 = @unigrams[bigram_words[0]].to_f
      w1w2 = good_turing_count(bigram_words.join(" "))
      w1 = good_turing_count(bigram_words[0])
      tempProb = (w1w2/w1)
      # P(w2|w1) * (P(w1))
      return (tempProb*probability_of_sequence(bigram_words[0]))
    else
      # P(w1) = c*(w1)/V
      return (good_turing_count(unigram_word)/@v_size.to_f)
      # return (@unigrams[unigram_word]/@v_size.to_f)
    end

  end

  # returns smoothed count
  def add_one(sequence)
    words = sequence.split(" ")
    if words == ""
      return 0
    end

    unigram_word = words.last if words.count >= 1
    bigram_words = words.last(2) if words.count >= 2
    trigram_words = words.last(3) if words.count >= 3

    if words.count == 3
      if @trigrams[trigram_words[0] + " " + trigram_words[1]][trigram_words[2]] != nil
        # return (c(w1,w2,w3) + 1)*c(w1,w2)/(c(w1,w2)+V(bigrams)))
        cw1w2w3 = @trigrams[trigram_words[0] + " " + trigram_words[1]][trigram_words[2]]
        cw1w2 = @bigrams[trigram_words[0]][trigram_words[1]]

        return ((cw1w2w3 + 1)*cw1w2/(cw1w2+@bigrams.length).to_f)
      elsif @bigrams[trigram_words[0]][trigram_words[1]] != nil
        # return (1)*c(w1,w2)/(c(w1,w2)+V(bigrams))
        cw1w2 = @bigrams[trigram_words[0]][trigram_words[1]]
        return (cw1w2/(cw1w2+@bigrams.length).to_f)
      else
        # use backtracking to find a better count
        return 0
      end
    elsif words.count == 2
      if @bigrams[bigram_words[0]][bigram_words[1]] != nil
        # return (c(w1,w2) + 1)*c(w1)/(c(w1)+V(unigrams))
        cw1w2 = @bigrams[bigram_words[0]][bigram_words[1]]
        cw1 =  @unigrams[bigram_words[0]]

        return ((cw1w2 + 1)*cw1/(cw1+@unigrams.length).to_f)
      elsif @unigams[bigram_words[0]] != nil
        # return (1)*c(w1)/(c(w1)+V(bigrams))
        cw1 = @unigrams[bigram_words[0]]
        return (cw1/(cw1+@unigrams.length).to_f)
      else
        # words not found in vocabulary
        return 0
      end
    end
  end
  
end
