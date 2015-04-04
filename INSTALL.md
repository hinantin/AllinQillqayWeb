### Set Up Apache Virtual Host

##### Step 1. Install Apache

```
$ sudo apt-get install apache2
```

##### Step 2. Create a New Directory

```
$ sudo mkdir -p /var/www/allinqillqay.localhost/public_html
```

##### Step 3. Grant Permissions

```
$ sudo chown -R $USER:$USER /var/www/allinqillqay.localhost/public_html
$ sudo chmod -R 755 /var/www
```
##### Step 4. Create the Page

```
$ sudo ln -s /home/richard/Documents/AllinQillqayWeb/ClientSide/ckeditor \
/var/www/allinqillqay.localhost/public_html/ckeditor

$ sudo ln -s /home/richard/Documents/AllinQillqayWeb/ServerSide/WebSpellChecker/spellcheck31 \
/var/www/allinqillqay.localhost/public_html/spellcheck31

$ sudo ln -s /home/richard/Documents/AllinQillqayWeb/ServerSide/Hinantin/cgi-bin/spellcheck31 \
/usr/lib/cgi-bin/spellcheck31
```

##### Step 5. Create the New Virtual Host File

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

##### Step 6. Setting Up the Local Hosts

```
$ nano /etc/hosts 
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

##### Step . See Your Virtual Host in Action
Once you have finished setting up your virtual host, you can see how it looks online. Type your ip address into the browser (ie. http://allinqillqay.localhost)


