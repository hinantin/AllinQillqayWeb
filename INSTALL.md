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
