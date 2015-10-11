
class Trigrammodel
  attr_accessor :unigrams
  attr_accessor :bigrams
  attr_accessor :trigrams

  def initialize(unigrams, bigrams, trigrams)
    @unigrams = unigrams
    @bigrams = bigrams
    @trigrams = trigrams
  end

  # This method uses backtracking if no trigrams could be found
  def most_probable_next_word(string)
    words = string.split(" ")
    bigram_key = string.last
    trigram_key = string.last(2).join(" ")
    most_probable_word = ""

    ## if we want to find a trigram and trigram exists
    if words.count >= 2 and @trigrams[trigram_key] != nil
      # get w3 from grams with highest P(w3|w1,w2) = P(w3)*P(w2|w1)
      highest_probability = 0.0

      @trigrams[trigram_key].each do |word, prob|
        tempProb = prob*probability_of_sequence(trigram_key)
        # if P(w3)*P(w2|w1) > highest_probability
        if tempProb > highest_probability
          highest_probability = tempProb
          most_probable_word = word
        end
      end
    elsif words.count >= 1 and @bigrams[bigram_key] != nil
      # get w2 from grams with highest P(w2|w1)
      highest_probability = 0.0

      @bigrams[bigram_key].each do |word, prob|
        tempProb = prob*probability_of_sequence(bigram_key)
        # if P(w2|w1) > highest_probability
        if tempProb > highest_probability
          highest_probability = tempProb
          most_probable_word = word
        end
      end
    else
      # return random unigram?

    end
  end

  def probability_of_sequence(sequence)

  end
  
end
