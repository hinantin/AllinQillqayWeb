#!/bin/bash

rm -f test.dat
touch test.dat
python test.py --ifile=GoldStandard/20140623-GoldStandardTexts_SCE01.xml --iheader=true
#python test.py --ifile=GoldStandard/20140623-GoldStandardTexts_SCE02.xml --iheader=false
python test.py --ifile=GoldStandard/20140623-GoldStandardTexts_SCE03.xml --iheader=false

chmod +x test1.pg
./test1.pg > test1.png
