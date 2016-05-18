Word-Predictor
==============
The Brown corpus is also included in the zip-file and you do not have to download that.

These scripts are compatible with Ruby version >= 1.9.

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

## Run the program
After you have built the files with the n-grams, you can use the `searchTrigrams.rb` script to generate an new given a string. To start the script you type:
```sh
$ ruby searchTrigrams.rb
```

Write your sequence of words that you will generate a word to (the interpreter is case sensitive). Example:
```sh
->I was
Trigram, highest_probability: 3.3445780494608435e-06 Perplexity: 298991.378
I was hoping
```

To terminate, type `exit`.
