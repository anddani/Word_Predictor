require_relative 'ruby_nlp/corpus'
require_relative 'ruby_nlp/corpus_files/brown'

# corpus = Corpus.new('brown/ca01', BrownCorpusFile)
# corpus.trigrams
# corpus.files
#
# puts corpus.sentences.count

class Corpusreader
  attr_accessor :corpus

  def initialize(corpus_type)
    corpus_types = {
      :fiction    => 'brown/ck*',
      :government => 'brown/ch*',
      :adventure  => 'brown/cn*',
      :mystery    => 'brown/cl*',
      :experiment => 'testcorpus'
    }

    @corpus = Corpus.new(corpus_types[corpus_type], BrownCorpusFile)
  end

  def get_unigrams
    @corpus.unigrams
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
