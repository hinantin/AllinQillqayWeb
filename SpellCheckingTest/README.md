# Allin Qillqay - Testing Spellcheckers
# Testing

The following tests require Python.
The tests were runned on Ubuntu 12.04.

### Installing NLTK

```
$ sudo apt-get install python-nltk
```

### Installing gnuplot (optional)
If you wish to visualize graphically the results install gnuplot.

```
$ sudo apt-get install gnuplot
```

### Making a simple test

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

