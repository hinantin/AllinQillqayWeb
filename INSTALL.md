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
```



