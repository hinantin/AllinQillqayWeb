#### Installing the `Error Corpus` using eXist-db

##### Step 1. Install some packages

```
# eXistdb uses Java >=7
$ sudo apt-get install openjdk-7-jre
$ sudo apt-get install openjdk-7-jdk
# this package is necessary to make queries
$ sudo apt-get install librpc-xml-perl
```

##### Step 2. Download eXist-db

```
$ mkdir exist-db
$ cd exist-db
$ wget http://ufpr.dl.sourceforge.net/project/exist/Stable/2.2/eXist-db-setup-2.2.jar
```

##### Step 3. Install eXist-db

Create the folder for the program.

```
$ sudo mkdir -p /usr/share/eXist/
```

```
$ sudo java -jar eXist-db-setup-2.2.jar -console

Select target path [/home/ubuntu/exist-db] 
/usr/share/eXist/
press 1 to continue, 2 to quit, 3 to redisplay
1
Set Data Directory
Please select a directory where eXist-db will keep its data files. On Windows, this should be outside the 'Program Files' directory. Please make sure eXist can write to the directory it is installed in.
Data dir:  [webapp/WEB-INF/data] 

press 1 to continue, 2 to quit, 3 to redisplay
1
Set Admin Password and Configure Memory
Enter password:  [] 
admin
Enter password:  [admin] 
admin
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

##### Step 4. Install the service.
```
$ cd /usr/share/eXist
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
# Or starting the service manually
$ java -Xmx1024M -Djava.endorsed.dirs=lib/endorsed -jar start.jar jetty
```

##### Step 5. Running the client.

```
$ cd /usr/share/eXist
$ sudo bash bin/client.sh --no-gui -u admin -P admin
--no-gui -u admin -P admin
Using locale: en_US.UTF-8
eXist version 2.2 (master-5c5aadc), Copyright (C) 2001-2015 The eXist-db Project
eXist-db comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions; for details read the license file.


type help or ? for help.
exist:/db>mkcol HNTErrorCorpus
created collection.
exist:/db>cd HNTErrorCorpus
exist:/db/HNTErrorCorpus>mkcol cuz_simple_foma
exist:/db/HNTErrorCorpus>mkcol uni_simple_foma
exist:/db/HNTErrorCorpus>mkcol uni_extended_foma
exist:/db/HNTErrorCorpus>mkcol bol_myspell
exist:/db/HNTErrorCorpus>mkcol ec_hunspell
exist:/db/HNTErrorCorpus>quit
quit.
```

Adding a test using Perl

```
#!/usr/bin/perl
use RPC::XML;
use RPC::XML::Client;
$RPC::XML::ENCODING = 'utf-8';

$query = <<END;
for \$i in 1 to 10 return <xml>Text { \$i }</xml>
END
$URL = "http://admin:admin\@localhost:8080/exist/xmlrpc";
print "connecting to $URL...\n";
$client = new RPC::XML::Client $URL;
# Output options
$options = RPC::XML::struct->new(
    'indent' => 'yes', 
    'encoding' => 'UTF-8',
    'highlight-matches' => 'none');
$req = RPC::XML::request->new("query", $query, 20, 1, $options);
$response = $client->send_request($req);
if($response->is_fault) {
    die "An error occurred: " . $response->string . "\n";
}
print $response->value;
```

##### Step 6. Unccomment 

Open the following file:
```
$ gedit /usr/lib/cgi-bin/spellcheck31/script/ssrv.cgi
```
Uncomment the line that reads:

```
  #$object->AddDocumentToErrorCorpuseXistdb($text, $slang);
```

##### Making Backups

```
# Creating a backup (localhost)
$ cd /usr/share/eXist
$ sudo bin/backup.sh -u admin -p admin-pass -b /db -d /var/backup/hd060501

# Creating a backup (remote)
$ sudo bin/backup.sh -u admin -p admin-pass -b /db -d /var/backup/hd060501 -ouri=xmldb:exist://192.168.1.37:80/xmlrpc

# Restore a backup (localhost)
$ sudo bin/backup.sh -u admin -p admin-pass -P backup-pass -r /var/backup/hd060501/db/__contents__.xml
```

