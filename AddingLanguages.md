### Adding languages

In this manual we assume that you have already install AllinQillqay and the binaries for your spellchecker are compiled.

The following steps describe how to create a TCP Service for your own apellchecker.

##### INSTALLING THE TCP SERVERS

```
$ cd <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/SQUOIA/foma/
$ make
$ sudo make install
$ sudo cp suggestionsserver /usr/bin/
$ sudo chmod +x /usr/bin/fomaserver
$ sudo cp fomaserver /usr/bin/
```



```
# Creating the NEWLANGUAGE folder
$ sudo mkdir -p /usr/share/NEWLANGUAGE/
# Installing transducers
$ sudo cp NEWLANGUAGE.bin /usr/share/NEWLANGUAGE/
```
