# Test

Below we illustrate the process to calculate SER in programming language Python with NLTK.

```
$ python
Python 2.7.3 ... 
 >>> from nltk.metrics import edit_distance
 >>> from __future__ import division
 >>> # a is the misspelled word
 >>> a="Rimasharankiraqchusina"
 >>> # b is one of the suggestions offered 
 >>> # by the spell checker engine
 >>> b="Rimacharankiraqchusina"
 >>> # c is the reference word
 >>> c="Rimachkarqankiraqchusina"
 >>> round(edit_distance(a,b)/len(c), 2)
 0.04
```

