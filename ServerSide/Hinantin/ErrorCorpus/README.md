### Installing the *Error Corpora Management System* on Ubuntu 12.04

You can either use eXist-db or BaseX to store the `Error Corpus`, if you want to use exist-db see the `eXist-db.md` file, or continue below to use BaseX.

##### Step 1. Install BaseX XML Database (>= 7.8)

Download the necessary files (.dsc, orig.tar.gz and debian.tar.xz) from https://launchpad.net/ubuntu/+source/basex/7.9-1

or ...

```
$ wget https://launchpad.net/ubuntu/+archive/primary/+files/basex_7.9-1.dsc
$ wget https://launchpad.net/ubuntu/+archive/primary/+files/basex_7.9.orig.tar.gz
$ wget https://launchpad.net/ubuntu/+archive/primary/+files/basex_7.9-1.debian.tar.xz
```

###### Compiling or installing using a dsc files

```
$ dpkg-source -x basex_7.9-1.dsc
$ cd basex_7.9-1/
$ dpkg-buildpackage -rfakeroot -b
$ cd ..
```

In this step you should solve all the issues the installer points you out,
in order to obtain the deb file.

```
$ sudo dpkg -i basex_7.9-1.deb
```

###### Step 2. Run BaseX Server as a *service* on Ubuntu 12.04 startup

```
$ cd /your/own/path/AllinQillqayWeb/ServerSide/Hinantin/ErrorCorpus

$ sudo cp basex /etc/init.d
$ sudo chmod +x /etc/init.d/basex
$ sudo update-rc.d basex defaults
 Adding system startup for /etc/init.d/basex ...
   /etc/rc0.d/K20basex -> ../init.d/basex
   /etc/rc1.d/K20basex -> ../init.d/basex
   /etc/rc6.d/K20basex -> ../init.d/basex
   /etc/rc2.d/S20basex -> ../init.d/basex
   /etc/rc3.d/S20basex -> ../init.d/basex
   /etc/rc4.d/S20basex -> ../init.d/basex
   /etc/rc5.d/S20basex -> ../init.d/basex
```

You will need to restart your system

```
$ sudo reboot
```

##### Step 3. Creating the *HNTErrorCorpus* XML Database

By default *BaseX* creates the user *admin* with password *admin*, so if you did not modified those values you can employ them in the following instructions.

```
$ basexclient -nlocalhost -Uuser -Ppassword

> CREATE DB HNTErrorCorpus
Database 'HNTErrorCorpus' created in 281.39 ms.

> exit 

$ 
```

##### Step 4. Unccomment 

Open the following file:
```
$ gedit /usr/lib/cgi-bin/spellcheck31/script/ssrv.cgi
```
Uncomment the line that says:
```
  # $object->AddDocumentToErrorCorpus($text);
```

Notice that this will slow down your application.

In order to see the error corpus entries log into *BaseX* and type *xquery collection('HNTErrorCorpus')*

```
$ basexclient              
Username: admin
Password: 
BaseX 7.9 [Client]
Try help to get more information.

> xquery collection('HNTErrorCorpus')
```

You will see something like this:

```
</document><document id="doc_20150419014112">
  <text>mamay, waqachiq, punku, choqe, chaqllayuq, Punkuchaykita, kichaykullaway, Icharaq, mamaywan, tupaykullayman</text>
  <check_spelling engine_id="uni_simple_foma" engine_version="v1.0-beta.1">
    <entry type="spelled-correctly" id="1">
      <word>mamay</word>
    </entry>
    <entry type="spelled-correctly" id="2">
      <word>waqachiq</word>
    </entry>
    <entry type="spelled-correctly" id="3">
      <word>punku</word>
    </entry>
    <entry type="misspelling" id="4">
      <word>choqe</word>
      <length>5</length>
      <suggestions>
        <suggestion>chuqi</suggestion>
        <suggestion>chupi</suggestion>
        <suggestion>chupa</suggestion>
        <suggestion>chhuqu</suggestion>
        <suggestion>chuqin</suggestion>
        <suggestion>chhuqu</suggestion>
        <suggestion>chuqiy</suggestion>
        <suggestion>chuqis</suggestion>
        <suggestion>chuqim</suggestion>
        <suggestion>chuqip</suggestion>
        <suggestion>churi</suggestion>
        <suggestion>chusi</suggestion>
        <suggestion>chuki</suggestion>
        <suggestion>ch'aqi</suggestion>
        <suggestion>ch'iqi</suggestion>
      </suggestions>
    </entry>
    <entry type="spelled-correctly" id="5">
      <word>chaqllayuq</word>
    </entry>
    <entry type="spelled-correctly" id="6">
      <word>Punkuchaykita</word>
    </entry>
    <entry type="spelled-correctly" id="7">
      <word>kichaykullaway</word>
    </entry>
    <entry type="spelled-correctly" id="8">
      <word>Icharaq</word>
    </entry>
    <entry type="spelled-correctly" id="9">
      <word>mamaywan</word>
    </entry>
    <entry type="spelled-correctly" id="10">
      <word>tupaykullayman</word>
    </entry>
  </check_spelling>
</document>
Query executed in 313.64 ms.

```

