### Installing the Southern Unified Quechua, with an extended Spanish lexicon and a large set of correction rules spellchecker

Navigate to the following folder.

**Note:** In order to compile the transducers you need at least 4GB RAM. 
Otherwise it may crashed your computer or slow it down.

```
$ cd /home/richard/Documents/AllinQillqayWeb/ServerSide/SQUOIA/tcpServer/
# Download the spell checker
$ wget http://kitt.ifi.uzh.ch/kitt/squoia/downloads/spellChecker_19-05-2014.tar
$ tar -xvf spellChecker_19-05-2014.tar
$ cd spellChecker/analyzer/
$ foma -f analyzeUnificado.foma
$ foma -f spellcheckUnificado.foma
$ cd ../..
$ cd spellChecker/normalizer/
$ foma -f chain.foma
$ cd ../..
# Creating the SQUOIA folder
$ sudo mkdir -p /usr/share/squoia/
# Installing transducers
$ sudo cp spellChecker/analyzer/analyzeUnificado.bin /usr/share/squoia/
$ sudo cp spellChecker/analyzer/spellcheckUnificado.bin /usr/share/squoia/
$ sudo cp spellChecker/normalizer/chain.bin /usr/share/squoia/
```

### Compiling the tcpServer

```
$ cd foma
$ make
$ sudo cp tcpServer /usr/bin/
$ sudo chmod +x /usr/bin/tcpServer
```

### Installing the service on port 8888

```
$ sudo cp tcpServerSpellCheck /etc/init.d
$ sudo chmod +x /etc/init.d/tcpServerSpellCheck
$ sudo update-rc.d tcpServerSpellCheck defaults
 Adding system startup for /etc/init.d/tcpServerSpellCheck ...
   /etc/rc0.d/K20tcpServerSpellCheck -> ../init.d/tcpServerSpellCheck
   /etc/rc1.d/K20tcpServerSpellCheck -> ../init.d/tcpServerSpellCheck
   /etc/rc6.d/K20tcpServerSpellCheck -> ../init.d/tcpServerSpellCheck
   /etc/rc2.d/S20tcpServerSpellCheck -> ../init.d/tcpServerSpellCheck
   /etc/rc3.d/S20tcpServerSpellCheck -> ../init.d/tcpServerSpellCheck
   /etc/rc4.d/S20tcpServerSpellCheck -> ../init.d/tcpServerSpellCheck
   /etc/rc5.d/S20tcpServerSpellCheck -> ../init.d/tcpServerSpellCheck
```
You will need to restart your system

```
$ sudo reboot
```

### Testing the connection

Run the following command:

```
$ chmod +x tcpclient.pl 
```

In case the connection is not established:

```
$ ./tcpclient.pl 
cannot connect to the server Connection refused
```

In case the connection works:

```
$ ./tcpclient.pl 
connected to the server
sent data of length 6
received response: incorrect:ñawis,ñawim,ñawiy|correct:
```

