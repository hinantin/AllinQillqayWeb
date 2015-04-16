### Installing Bolivia Quechua &
### Ecuadorian Kichwa spellcheckers

**Installing MySpell and HunSpell spellcheckers**
```
# MySpell Bolivian Quechua
$ cd /home/richard/Documents/AllinQillqayWeb/ServerSide/Hunspell
$ mkdir dict-quh_BO
$ unzip dict-quh_BO.oxt -d dict-quh_BO
$ sudo cp dict-quh_BO/dictionaries/quh_BO.aff /usr/share/hunspell/
$ sudo cp dict-quh_BO/dictionaries/quh_BO.dic /usr/share/hunspell/

# 
$ mkdir qu_ec-0.9b
$ unzip qu_ec-0.9b.oxt -d qu_ec-0.9b
$ sudo cp qu_ec-0.9b/qu_EC.dic /usr/share/hunspell/
$ sudo cp qu_ec-0.9b/qu_EC.aff /usr/share/hunspell/

```

