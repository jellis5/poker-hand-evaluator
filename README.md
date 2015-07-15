# poker-hand-evaluator
Evaluates specific hands inputted. Also can generate random hands and evaluate them.

Usage: ruby evaluate.rb [options]
    -s, --as-string STRING           Pass in hand as string to be evaluated
    -r, --random NUM                 Run NUM random hands
    -t, --threads NUM                Multithreading for random hands. Use only with non-GIL implementations (like JRuby and Rubinius)
