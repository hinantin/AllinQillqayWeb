### Download eXist-db

```
$ mkdir exist-db
$ cd exist-db
$ wget http://ufpr.dl.sourceforge.net/project/exist/Stable/2.2/eXist-db-setup-2.2.jar
```

### Install eXist-db

Create the folder for the program.

```
$ sudo mkdir -p /applications/eXist/
```

```
$ sudo java -jar eXist-db-setup-2.2.jar -console

Select target path [/home/ubuntu/exist-db] 
/applications/eXist/
press 1 to continue, 2 to quit, 3 to redisplay
1
Set Data Directory
Please select a directory where eXist-db will keep its data files. On Windows, this should be outside the 'Program Files' directory. Please make sure eXist can write to the directory it is installed in.
Data dir:  [webapp/WEB-INF/data] 

press 1 to continue, 2 to quit, 3 to redisplay
1
Set Admin Password and Configure Memory
Enter password:  [] 
hinantin01
Enter password:  [hinantin01] 
hinantin01
------------------------------------------

Maximum memory in mb: [1024] 

Cache memory in mb: [128] 

press 1 to continue, 2 to quit, 3 to redisplay
1
[ Starting to unpack ]
[ Processing package: Sources (1/15) ]
[ Processing package: Core (2/15) ]
[ Processing package: Apps (3/15) ]
[ Processing package: shared (4/15) ]
[ Processing package: bf-XForms (5/15) ]
[ Processing package: dashboard (6/15) ]
[ Processing package: demo (7/15) ]
[ Processing package: doc (8/15) ]
[ Processing package: eXide (9/15) ]
[ Processing package: fundocs (10/15) ]
[ Processing package: markdown (11/15) ]
[ Processing package: monex (12/15) ]
[ Processing package: xqjson (13/15) ]
[ Processing package: xsltforms (14/15) ]
[ Processing package: xsltforms-demo (15/15) ]
[ Unpacking finished ]
[ Starting processing ]
Starting process Setting admin password ... (1/1)
--- Starting embedded database instance ---
Apr 25, 2015 5:20:23 PM org.expath.pkg.repo.util.Logger info
INFO: Create a new repository with storage: File system storage in /applications/eXist/webapp/WEB-INF/data/expathrepo
Setting admin user password...
--- Initialization complete. Shutdown embedded database instance ---
[ Console installation done ]
```

Install the service.
```
$ cd /applications/eXist
$ sudo tools/wrapper/bin/exist.sh install
Detected Ubuntu or Debian:
Installing the eXist-db Native XML Database daemon using init.d..
 Adding system startup for /etc/init.d/eXist-db ...
   /etc/rc0.d/K20eXist-db -> ../init.d/eXist-db
   /etc/rc1.d/K20eXist-db -> ../init.d/eXist-db
   /etc/rc6.d/K20eXist-db -> ../init.d/eXist-db
   /etc/rc2.d/S20eXist-db -> ../init.d/eXist-db
   /etc/rc3.d/S20eXist-db -> ../init.d/eXist-db
   /etc/rc4.d/S20eXist-db -> ../init.d/eXist-db
   /etc/rc5.d/S20eXist-db -> ../init.d/eXist-db

$ sudo reboot
```
