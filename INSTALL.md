## Set Up The Server Side on Ubuntu 16.04
### Set Up Apache Virtual Host

#### Change the url `allinqillqay.localhost` if that is not the url want.

#### `<ALLINQILLQAY_PATH>`

`<ALLINQILLQAY_PATH>` is used throughout this manual to refer to 
the path where you have downloaded AllinQillqayWeb, in my case 
the path is `/home/richard/Documents`. You should change this to 
adjust it to your own environment.

##### Step 1. Install Apache, and necessary programs

```
$ sudo apt-get install apache2
$ sudo apt-get install zlib1g-dev flex bison libreadline-dev
$ sudo apt-get install hunspell
$ sudo apt-get install libio-captureoutput-perl
$ sudo apt-get install libconfig-inifiles-perl
$ sudo apt-get install libdatetime-perl
$ sudo apt-get install libxml-writer-perl
$ sudo apt-get install libmoose-perl
$ sudo apt-get install librpc-xml-perl
$ sudo apt-get install libdbi-perl
$ sudo apt-get install libdbd-mysql-perl
```

##### Step 2. Create a New Directory

```
$ sudo mkdir -p /var/www/html/allinqillqay.localhost/public_html
```

##### Step 3. Grant Permissions

```
$ sudo chown -R $USER:$USER /var/www/html/allinqillqay.localhost/public_html
$ sudo chmod -R 755 /var/www/html
```
##### Step 4. Create the Page

```
$ sudo ln -s <ALLINQILLQAY_PATH>/AllinQillqayWeb/ClientSide/ckeditor \
/var/www/html/allinqillqay.localhost/public_html/ckeditor

$ sudo ln -s <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/WebSpellChecker/spellcheck31 \
/var/www/html/allinqillqay.localhost/public_html/spellcheck31
```

##### Step 5. Configure cgi-bin, compile foma, and spellcheckers

```
$ cd <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/Hinantin/cgi-bin 
$ sudo cp -a spellcheck31 /usr/lib/cgi-bin/
$ cd /usr/lib/cgi-bin/spellcheck31/script/
$ sudo chmod o+x ssrv.cgi
```

**Compiling Foma files**

```
$ cd <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/SQUOIA/foma/
$ make
$ sudo make install
$ sudo cp suggestions /usr/bin/
$ sudo chmod +x /usr/bin/suggestions
```
**Create the default folder for the transducers**

```
$ sudo mkdir -p /usr/share/squoia/
```

**Compiling transducers**

```
# Cuzco Quechua
$ cd <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/SQUOIA
$ tar -xvf squoiaSpellCheckCuzco.tar
$ cd spellcheckCuzco_foma
$ foma -f spellcheck.foma
$ sudo cp spellcheck.fst /usr/share/squoia/

# Southern Unified Quechua
$ cd <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/SQUOIA
$ tar -xvf squoiaSpellCheckUnificado.tar
$ cd spellcheckUnificado_foma
$ foma -f spellcheckUnificado.foma
$ sudo cp spellcheckUnificado.fst /usr/share/squoia/
```
**Activating the Bolivia Quechua & Ecuadorian Kichwa spellcheckers**

See `AllinQillqayWeb/ServerSide/Hunspell/README.md` for a detailed installation guide.

**Activating the improved version of the southern unified quechua spellchecker**

See `AllinQillqayWeb/ServerSide/SQUOIA/tcpServer/README.md` for a detailed installation guide.


##### Step 6. Create the New Virtual Host File (Only for Ubuntu 12.04 LTS)


```
$ sudo cp /etc/apache2/sites-available/default /etc/apache2/sites-available/allinqillqay.localhost

$ sudo nano /etc/apache2/sites-available/allinqillqay.localhost
```

We are going to set up a virtual host in this file.

The first step is to insert a line for the ServerName under the ServerAdmin line.

```
  ServerName allinqillqay.localhost 
```

The next step is to fill in the correct Document Root. 

```
  DocumentRoot /var/www/allinqillqay.localhost/public_html 
```

The last step is to activate the host, with the built in apache shortcut:

```
$ sudo a2ensite allinqillqay.localhost

$ sudo service apache2 restart
```

##### Step 7. Setting Up the Local Hosts

```
$ sudo nano /etc/hosts 
```

You can add the local hosts details to this file, as seen in the example below. As long as that line is there, directing your browser toward, say, allinqillqay.localhost will give you all the virtual host details for the corresponding IP address.

```
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost

#Virtual Hosts 
127.0.0.1       allinqillqay.localhost

```

##### Step 8. See Your Virtual Host in Action
Once you have finished setting up your virtual host, you can see how it looks online. Type your ip address into the browser (ie. http://allinqillqay.localhost/ckeditor/samples/api.html)

##### Step 9. Change URL (Optional)

Change the url `allinqillqay.localhost` within the file to the one you want.

```
nano <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/WebSpellChecker/spellcheck31/lf/scayt3/ckscayt/ckscayt.js
```

###### Note: checking last php/cgi errors

```
$ tail -f /var/log/apache2/error.log

```
##### Step 10. Activating User Dictionary characteristics

See `AllinQillqayWeb/ServerSide/Hinantin/UserDictionary/README.md` for a detailed installation guide.

### Installing the advanced features (Optional)

##### Step 11. Activating Error Corpora functionalities

See `AllinQillqayWeb/ServerSide/Hinantin/ErrorCorpus/README.md` for a detailed installation guide.


## Set Up The Client Side
### Redirect to url

##### Step 1. Change URL (Optional)

Change the url `allinqillqay.localhost` within the file to the one you want.

```
nano <ALLINQILLQAY_PATH>/AllinQillqayWeb/ClientSide/ckeditor/ckeditor.js
```


