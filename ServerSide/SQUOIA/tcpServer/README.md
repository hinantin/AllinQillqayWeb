### Installing the uni_extended_foma

Navigate to the following folder

```
$ cd /home/richard/Documents/AllinQillqayWeb/ServerSide/SQUOIA/tcpServer/
# Download the spell checker
$ wget wget http://kitt.ifi.uzh.ch/kitt/squoia/downloads/spellChecker_19-05-2014.tar
$ tar -xvf spellChecker_19-05-2014.tar
$ cd spellChecker/normalizer/
$ foma -f chain.foma
$ foma -f analyzeUnificado.foma
$ foma -f spellcheckUnificado.foma

$ sudo mkdir -p /usr/share/squoia/
$ sudo cp bin/analyzeUnificado.bin /usr/share/squoia/
$ sudo cp bin/chain.bin /usr/share/squoia/
$ sudo cp bin/spellcheckUnificado.bin /usr/share/squoia/

```
