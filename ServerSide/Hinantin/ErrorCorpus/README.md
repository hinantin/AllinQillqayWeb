COMPILING/INSTALLING THE DSC
============================

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

RUNNING ON STARTUP - UBUNTU
===========================

```
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


```
$ basexclient -nlocalhost -Uuser -Ppassword

CREATE DB HNTQhichwaErrorCorpus
SET AUTOFLUSH false
ADD example.xml
SET ADDCACHE true
ADD /path/to/xml/documents
STORE TO images/ 123.jpg
FLUSH
DELETE /

```

