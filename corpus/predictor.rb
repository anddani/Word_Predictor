require "ruby_nlp/corpus"
require "ruby_nlp/corpus_files/brown"

# corpus = Corpus.new('brown/ca01', BrownCorpusFile)
# corpus.trigrams
# corpus.files
#
# puts corpus.sentences.count

class Predictor
  attr_accessor :corpus

  def initialize(grams, corpus_type)
    corpus_file = {
      :fiction    => 'brown/ck*',
      :government => 'brown/ch*',
      :adventure  => 'brown/cn*',
      :mystery    => 'brown/cl*',
      :test       => 'testcorpus',
      :experiment => 'testcorpus2'
    }

    @corpus = Corpus.new(corpus_file[corpus_type], BrownCorpusFile)
  end

  def get_bigrams
    @corpus.bigrams
  end

  def get_trigrams
    @corpus.trigrams
  end

  def print2_trigrams
    corp = @corpus.trigrams
    puts corp.length
    puts corp.uniq.length
  end

end
