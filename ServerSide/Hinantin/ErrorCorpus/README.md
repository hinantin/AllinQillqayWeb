### Installing the *Error Corpora Management System* on Ubuntu 12.04

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

```
$ basexclient -nlocalhost -Uuser -Ppassword

> CREATE DB HNTErrorCorpus
Database 'HNTErrorCorpus' created in 281.39 ms.

> SET AUTOFLUSH false
> ADD example.xml
> SET ADDCACHE true
> ADD /path/to/xml/documents
> STORE TO images/ 123.jpg
> FLUSH
> DELETE /

> exit 

$ 

```

