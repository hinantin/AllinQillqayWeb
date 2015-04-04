### Set Up Apache Virtual Host

1. Install Apache

```
$ sudo apt-get install apache2
```

2. Create a New Directory

```
$ sudo mkdir -p /var/www/allinqillqay.localhost/public_html
```

3. Grant Permissions

```
$ sudo chown -R $USER:$USER /var/www/allinqillqay.localhost/public_html
$ sudo chmod -R 755 /var/www
```
4. Create the Page

```
$ sudo ln -s /home/richard/Documents/AllinQillqayWeb/ClientSide/ckeditor \
/var/www/allinqillqay.localhost/public_html/ckeditor

$ sudo ln -s /home/richard/Documents/AllinQillqayWeb/ServerSide/Hinantin/cgi-bin/spellcheck31 \
/usr/lib/cgi-bin/spellcheck31


```
