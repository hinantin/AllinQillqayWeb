### Installing Bolivia Quechua & Ecuadorian Kichwa spellcheckers

**Installing MySpell and HunSpell spellcheckers**

Navigate to the folder where the *.oxt files are.

```
$ cd /home/richard/Documents/AllinQillqayWeb/ServerSide/Hunspell
# MySpell Bolivian Quechua
$ mkdir dict-quh_BO
$ unzip dict-quh_BO.oxt -d dict-quh_BO
$ sudo cp dict-quh_BO/dictionaries/quh_BO.aff /usr/share/hunspell/
$ sudo cp dict-quh_BO/dictionaries/quh_BO.dic /usr/share/hunspell/
$ rm -rf dict-quh_BO

# Testing: if the word is incorrect there will be no answers, if it is right the same word will be printed.
$ echo "wasicha" | hunspell -G -d quh_BO
$ echo "wasin" | hunspell -G -d quh_BO
wasin

# Testing spellchecker, getting suggestions
$ echo "wasim" | hunspell -d quh_BO
Hunspell 1.3.2
& wasim 6 0: wasin, wasi, wasimá, wasis, wasiy, warmimasi

# HunSpell Ecuadorian Kichwa 
$ mkdir qu_ec-0.9b
$ unzip qu_ec-0.9b.oxt -d qu_ec-0.9b
$ sudo cp qu_ec-0.9b/qu_EC.dic /usr/share/hunspell/
$ sudo cp qu_ec-0.9b/qu_EC.aff /usr/share/hunspell/
$ rm -rf qu_ec-0.9b

# Testing: if the word is incorrect there will be no answers, if it is right the same word will be printed.
$ echo "wasicha" | hunspell -G -d qu_EC 
$ echo "wasi" | hunspell -G -d qu_EC 
wasi

# Testing spellchecker, getting suggestions
$ echo "wasim" | hunspell -d qu_EC
Hunspell 1.3.2
& wasim 2 0: wasi, wasimi

```

