#!/usr/bin/python

from __future__ import division
from nltk.metrics import edit_distance
import xml.etree.ElementTree as ET
import sys, getopt

def main(argv):
  inputfile = ''
  inputheader = ''
  try:
     opts, args = getopt.getopt(argv,"hi:d:",["ifile=","iheader="])
  except getopt.GetoptError:
     print 'test.py -i <inputfile> -o <inputheader>'
     sys.exit(2)
  for opt, arg in opts:
     if opt == '-h':
        print 'test.py -i <inputfile> -d <outputfile>'
        sys.exit()
     elif opt in ("-i", "--ifile"):
        inputfile = arg
     elif opt in ("-d", "--iheader"):
        inputheader = arg
  print inputfile
  header = '##engine '
  body = ''
  tree = ET.parse(inputfile)
  root = tree.getroot()
  
  for headernode in root.findall('header'):
    for tool in headernode.iter('tool'):
      body = body + tool.attrib["engine"] + ' '
    #body = body + tool.attrib["engine"] + ' '
  
  for word in root.iter('word'):
    original = word.find('original').text
    header = header + original + ' '
    status = word.find('status').text
    if status == 'SplErr':
      expected = word.find('expected').text
      # a is the misspelled word
      a = original
      # c is the reference word
      c = expected
      count = 0
      total = 0
      for suggestion in word.iter('suggestion'):
        # b is one of the suggestions offered 
        # by the spell checker engine
        b = suggestion.text
        count = count + 1
        total = total + round(edit_distance(a,b)/len(c), 2)
      result = total / count
      body = body + str(round(result,3)) + ' '
    else:
      body = body + '0 '
  
  f = open('test.dat', 'a')
  if (inputheader == 'true'):
    f.write(header+'\n')
  f.write(body+'\n')
  
if __name__ == "__main__":
  main(sys.argv[1:])
