### Installing Bolivia Quechua & Ecuadorian Kichwa spellcheckers

**Installing MySpell and HunSpell spellcheckers**

You need to have hunspell installed.

```
sudo apt-get install hunspell
```

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

### Compiling the TCP Service

```
$ cd hunspell-1.3.3
$ ./configure
$ make
$ cd src/hunspell
$ rm -f tcpServerHun; g++ -o tcpServerHun tcpServerHun.cxx .libs/libhunspell-1.3.a -lz
$ chmod +x tcpServerHun
$ sudo cp tcpServerHun /usr/bin/
$ echo "ñawi" | ./tcpServerHun /usr/share/hunspell/quh_BO.aff /usr/share/hunspell/quh_BO.dic
UTF-8

ñawi

$ echo "ñawiiy" | ./tcpServerHun /usr/share/hunspell/quh_BO.aff /usr/share/hunspell/quh_BO.dic
UTF-8
+?
"ñawiy","ñawpiy","ñawi",

$ echo "ñawi" | ./tcpServerHun /usr/share/hunspell/qu_EC.aff /usr/share/hunspell/qu_EC.dic
UTF-8

ñawi

$ echo "ñawiiy" | ./tcpServerHun /usr/share/hunspell/qu_EC.aff /usr/share/hunspell/qu_EC.dic
UTF-8

+?
"ñawi",

$ cd ../../..
```

### Creating the Service

```
$ cd qu_EC
$ sudo cp tcpServerquEC /etc/init.d
$ sudo chmod +x /etc/init.d/tcpServerquEC
$ sudo update-rc.d tcpServerquEC defaults
 Adding system startup for /etc/init.d/tcpServerquEC ...
   /etc/rc0.d/K20tcpServerquEC -> ../init.d/tcpServerquEC
   /etc/rc1.d/K20tcpServerquEC -> ../init.d/tcpServerquEC
   /etc/rc6.d/K20tcpServerquEC -> ../init.d/tcpServerquEC
   /etc/rc2.d/S20tcpServerquEC -> ../init.d/tcpServerquEC
   /etc/rc3.d/S20tcpServerquEC -> ../init.d/tcpServerquEC
   /etc/rc4.d/S20tcpServerquEC -> ../init.d/tcpServerquEC
   /etc/rc5.d/S20tcpServerquEC -> ../init.d/tcpServerquEC

$ cd ../quh_BO
$ sudo cp tcpServerquhBO /etc/init.d
$ sudo chmod +x /etc/init.d/tcpServerquhBO
$ sudo update-rc.d tcpServerquhBO defaults
 Adding system startup for /etc/init.d/tcpServerquhBO ...
   /etc/rc0.d/K20tcpServerquhBO -> ../init.d/tcpServerquhBO
   /etc/rc1.d/K20tcpServerquhBO -> ../init.d/tcpServerquhBO
   /etc/rc6.d/K20tcpServerquhBO -> ../init.d/tcpServerquhBO
   /etc/rc2.d/S20tcpServerquhBO -> ../init.d/tcpServerquhBO
   /etc/rc3.d/S20tcpServerquhBO -> ../init.d/tcpServerquhBO
   /etc/rc4.d/S20tcpServerquhBO -> ../init.d/tcpServerquhBO
   /etc/rc5.d/S20tcpServerquhBO -> ../init.d/tcpServerquhBO

```
