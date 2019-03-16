### Adding languages

In this manual we assume that you have already install [AllinQillqay](https://github.com/hinantin/AllinQillqayWeb/blob/master/INSTALL.md) and the binaries for your spellchecker are compiled (`error_correction.fst, error_detection.fst`).

`error_detection.fst` is a transdducer that returns the analysis of a simple entry.

`error_correction.fst` is a modified version of the error_detection.fst transducer that contains the confusion matrix.

```
# Creating the NEWLANGUAGE folder
$ sudo mkdir -p /usr/share/NEWLANGUAGE/
# Installing transducers
$ sudo cp error_detection.fst /usr/share/NEWLANGUAGE/
$ sudo cp error_correction.fst /usr/share/NEWLANGUAGE/
```

##### INSTALLING THE TCP SERVERS

The following steps describe how to create a TCP Service for your own apellchecker.

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
$ /etc/init.d/tcpServerErrorCorrection start 

# Error detection
$ sudo cp fomaserver /usr/bin/
$ sudo chmod +x /usr/bin/fomaserver
# Installing the service on port 7890
$ sudo cp <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/Hinantin/NEWLANGUAGE/tcpServerErrorDetection /etc/init.d
$ sudo chmod +x /etc/init.d/tcpServerErrorDetection
$ sudo update-rc.d tcpServerErrorDetection defaults
$ /etc/init.d/tcpServerErrorDetection start
```

If you wish to install the binaries in another folder other than `/usr/share/NEWLANGUAGE/` or use other ports, you will have to modify the variables in 
`/usr/lib/cgi-bin/spellcheck31/script/ssrv.cgi` 

```
# Modifying the path 
  my $hinantinpath = "/usr/share/NEWLANGUAGE";
```

```
# Modifying the ports 
  elsif ($slang eq "newlanguage_foma") {
    $object = SpellCheckAshaninkaMorph->new(
    FstFile => "$hinantinpath/error_correction.fst",
    EngineName => "$slang",
    EngineVersion => "v1.0-beta.1",
    Type => "cmd",
    PeerHostErrorDetection => '127.0.0.1',
    PeerPortErrorDetection => '7890',
    PeerHostErrorCorrection => '127.0.0.1',
    PeerPortErrorCorrection => '7891',
    Proto => 'tcp',
    );
  }
```


##### EXECUTING THE SPELL-CHECKER AS A TERMINAL PROCESS

In order to run the spell-checker just replace the lines above in `/usr/lib/cgi-bin/spellcheck31/script/ssrv.cgi` with the ones below:

```
  elsif ($slang eq "newlanguage_foma") {
    $object = SpellCheckFiniteStateCmd->new(
    FstFile => "/usr/share/NEWLANGUAGE/error_correction.fst",
    EngineName => "$slang",
    EngineVersion => "v1.0-beta.1",
    Type => "cmd",
    );
  }
```

Install the suggestions executable:

```
$ cd <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/SQUOIA/foma/
$ make
$ sudo make install
$ sudo cp suggestions /usr/bin/
$ sudo chmod +x /usr/bin/suggestions
```

In order to change the language list you will have to modify the JSON-formatted list (adding or deleting elements to it) within the file `/usr/lib/cgi-bin/spellcheck31/script/ssrv.cgi` 

Change only "NEW LANGUAGE" to your own language:

```
"newlanguage_foma" : "NEW LANGUAGE"
```

in

```
  print $callback . '({langList:{ltr: {"cuz_simple_foma" : "Quechua Cusqueño", "uni_simple_foma" : "Quechua Sureño", "uni_extended_foma" : "Quechua Sureño Extendido", "bol_myspell" : "Quechua Boliviano", "ec_hunspell" : "Kichwa Ecuatoriano", "newlanguage_foma" : "NEW LANGUAGE"},rtl: {}},verLang : 6})';
```

The USER DICTIONARY is disable by default as it is not GDPR compliant, but if you wish to use it the comfiguration file is located in:

```
/usr/lib/cgi-bin/spellcheck31/script/ConfigFile.ini 
```

##### TESTING

[ASHANINKA SPELLCHECKER](https://hinant.in/ckeditor/samples/api.html)

