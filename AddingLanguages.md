### Adding languages

In this manual we assume that you have already install AllinQillqay and the binaries for your spellchecker are compiled (`error_correction.fst, error_detection.fst`).

The following steps describe how to create a TCP Service for your own apellchecker.

##### INSTALLING THE TCP SERVERS

```
$ cd <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/SQUOIA/foma/
$ make
$ sudo make install

# Error correction 
$ sudo cp suggestionsserver /usr/bin/
$ sudo chmod +x /usr/bin/suggestionsserver
# Installing the service on port 7891
$ sudo cp <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/Hinantin/NEWLANGUAGE/tcpServerErrorCorrection /etc/init.d
$ sudo chmod +x /etc/init.d/tcpServerErrorCorrection
$ sudo update-rc.d tcpServerErrorCorrection defaults

# Error detection
$ sudo cp fomaserver /usr/bin/
$ sudo chmod +x /usr/bin/fomaserver
# Installing the service on port 8888
$ sudo cp tcpServerSpellCheck /etc/init.d
$ sudo chmod +x /etc/init.d/tcpServerSpellCheck
$ sudo update-rc.d tcpServerSpellCheck defaults


```



```
# Creating the NEWLANGUAGE folder
$ sudo mkdir -p /usr/share/NEWLANGUAGE/
# Installing transducers
$ sudo cp NEWLANGUAGE.bin /usr/share/NEWLANGUAGE/
```
