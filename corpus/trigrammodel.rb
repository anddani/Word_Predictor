
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

      @unigrams.each_key do |word|
        tempProb = probability_of_sequence(trigram_key + " " + word)
        # if P(w1)*P(w2|w1)*P(w3|w1,w2) > highest_probability
        if tempProb > highest_probability
          highest_probability = tempProb
          most_probable_word = word
        end
      end

      puts "ERROR IN TRIGRAMS" if highest_probability == 0.0
      puts "Trigram, highest_probability: " + highest_probability.to_s + " Perplexity: " + perplexity(highest_probability, 3).round(4).to_s
      return most_probable_word
    ## if we can find a bigram and bigram exists
    elsif words.count >= 1 and @bigrams[bigram_key] != nil
      # get w2 from grams with highest P(w2|w1)
      highest_probability = 0.0

      @unigrams.each_key do |word|
        tempProb = probability_of_sequence(bigram_key + " " + word)
        # if P(w1)*P(w2|w1) > highest_probability
        if tempProb > highest_probability
          highest_probability = tempProb
          most_probable_word = word
        end
      end
      puts "ERROR IN BIGRAMS" if highest_probability == 0.0
      puts "Bigram, highest_probability: " + highest_probability.to_s + " Perplexity: " + perplexity(highest_probability, 2).round(4).to_s
      return most_probable_word
    ## return random unigram?
    else
      highest_probability = 0.0
      @unigrams.each_key do |word|
        tempProb = probability_of_sequence(word)
        # if P(w1)*P(w2|w1) > highest_probability
        if tempProb > highest_probability
          highest_probability = tempProb
          most_probable_word = word
        end
      end
      puts "Unigram, highest_probability: " + highest_probability.to_s + " Perplexity: " + perplexity(highest_probability, 1).round(4).to_s
      return most_probable_word
    end
  end

  def perplexity(probability, gram)
    return probability ** (-1/gram)
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
      w1w2w3 = add_one(trigram_words.join(" "))
      w1w2 = add_one(trigram_words[0] + " " + trigram_words[1])
      tempProb = (w1w2w3/w1w2)
      # P(w1,w2,w3) = P(w3|w1,w2) * (P(w1)*P(w2|w1))
      return (tempProb*probability_of_sequence(trigram_words[0] + " " + trigram_words[1]))
    elsif words.count >= 2
      # P(w2|w1) = c*(w1,w2)/c*(w1)
      w1w2 = add_one(bigram_words.join(" "))
      w1 = add_one(bigram_words[0])
      return 0.0 if w1w2 == nil or w1 == nil
      tempProb = (w1w2/w1)
      # P(w1,w2) = P(w2|w1) * (P(w1))
      return (tempProb*probability_of_sequence(bigram_words[0]))
    else
      # P(w1) = c*(w1)/V
      return (add_one(unigram_word)/@v_size.to_f)
    end
  end

  # returns smoothed count
  def add_one(sequence)
    words = sequence.split(" ")
    if words == ""
      return 0.0
    end

    unigram_word = words.last if words.count >= 1
    bigram_words = words.last(2) if words.count >= 2
    trigram_words = words.last(3) if words.count >= 3

    if words.count == 3
      if @trigrams[trigram_words[0] + " " + trigram_words[1]] != nil
        if @trigrams[trigram_words[0] + " " + trigram_words[1]][trigram_words[2]] != nil
          # return (c(w1,w2,w3) + 1)*c(w1,w2)/(c(w1,w2)+V))
          cw1w2w3 = @trigrams[trigram_words[0] + " " + trigram_words[1]][trigram_words[2]]
          cw1w2 = @bigrams[trigram_words[0]][trigram_words[1]]

          return ((cw1w2w3 + 1)*cw1w2/(cw1w2+@v_size).to_f)
        else
          # return (1)*c(w1,w2)/(c(w1,w2)+V)
          cw1w2 = @bigrams[trigram_words[0]][trigram_words[1]]
          return (cw1w2/(cw1w2+@v_size).to_f)
        end
      else 
        # words not found in vocabulary
        return 0.0
      end
    elsif words.count == 2
      if @bigrams[bigram_words[0]] != nil
        if @bigrams[bigram_words[0]][bigram_words[1]] != nil
          # return (c(w1,w2) + 1)*c(w1)/(c(w1)+V)
          cw1w2 = @bigrams[bigram_words[0]][bigram_words[1]]
          cw1 = @unigrams[bigram_words[0]]

          return ((cw1w2 + 1)*cw1/(cw1+@v_size).to_f)
        else
          # return (1)*c(w1)/(c(w1)+V)
          cw1 = @unigrams[bigram_words[0]]
          return (cw1/(cw1+@v_size).to_f)
        end
      else
        # words not found in vocabulary
        return 0.0
      end
    elsif words.count == 1
      if @unigrams[unigram_word] != nil
        # return (1)*c(w1)/(c(w1)+V)
        cw1 = @unigrams[unigram_word]
        return (cw1/(cw1+@v_size).to_f)
      else
        # word not found in vocabulary
        return 0.0
      end
    else 
      puts "ERROR IN ADD_ONE"
      return 0.0
    end
  end
  
end
