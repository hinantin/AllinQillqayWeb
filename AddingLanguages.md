### Adding languages

In this manual we assume that you have already install AllinQillqay and the binaries for your spellchecker are compiled.

```
$ cd <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/SQUOIA/foma/
$ make
$ sudo make install
$ sudo cp suggestionsserver /usr/bin/
$ sudo chmod +x /usr/bin/suggestionsserver
```

The following steps describe how to create a TCP Service for your own apellchecker.

```
# Creating the NEWLANGUAGE folder
$ sudo mkdir -p /usr/share/NEWLANGUAGE/
# Installing transducers
$ sudo cp NEWLANGUAGE.bin /usr/share/NEWLANGUAGE/
```
