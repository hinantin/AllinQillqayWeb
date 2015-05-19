### Installing the *User Dictionary* on Ubuntu 12.04

##### Step 1. Install MySQL

```
$ sudo apt-get install mysql-server-5.5
```

Once you have entered the password for sudo access, the installation will 
proceed. The only thing it will ask you is what to set the root password for 
MySQL as. You **SHOULD** set a password up, don’t leave it blank with the intention 
of doing it later. I would recommend you find a decent password generator too
(i.e. https://strongpasswordgenerator.com/).

##### Step 2. Create the HNTUserDictionary Database and User 

Log into MySQL:

```
$ cd <ALLINQILLQAY_PATH>/AllinQillqayWeb/ServerSide/Hinantin/UserDictionary

$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 49
Server version: 5.5.40-0ubuntu0.12.04.1 (Ubuntu)

Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 


```

Create the *HNTUserDictionary* database and a *user* (**Note**: The 'user' 
and 'password' can be adjusted to your preferences, change them as you may.)

```
mysql> DROP DATABASE IF EXISTS `HNTUserDictionary`;
Query OK, 1 row affected (0.00 sec)

mysql> CREATE DATABASE `HNTUserDictionary` CHARACTER SET UTF8 COLLATE utf8_spanish_ci;
Query OK, 1 row affected (0.00 sec)

mysql> CREATE USER user@localhost;
Query OK, 0 rows affected (0.00 sec)

mysql> SET PASSWORD FOR user@localhost= PASSWORD("password");
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT ALL PRIVILEGES ON `HNTUserDictionary`.* TO user@localhost IDENTIFIED BY 'password';
Query OK, 0 rows affected (0.00 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)
```

Run the scripts:

```
mysql> source HNTUserDictionary_CreationScript.sql

mysql> source HNTUserDictionary_Procedures.sql

mysql> source UserDictionary.sql

mysql> exit
```




 
