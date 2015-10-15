Word-Predictor
==============
This word predictor uses the ruby gem (library) ruby_nlp. We packaged this gem in the provided zip-file and you will not have to download and install the gem. Reference to the gem: https://github.com/nathankleyn/ruby_nlp.git

The Brown corpus is also included in the zip-file and you do not have to download that.

These scripts are compatible with ruby version >= 1.9.

## Corpus setup
In the `getGrams.rb` file you can choose which of the corpora you want to be used as a training data. Change the symbol to the desired corpus name. The corpora to choose between are:

1. `:fiction`
2. `:government`
3. `:adventure`
4. `:mystery`
5. `:experiment`

## Build training data
You can build the `v_size.txt`, `unigrams.txt`, `bigrams.txt` and `trigrams.txt` by running the following script:
```sh
$ ruby getGrams.rb
```
