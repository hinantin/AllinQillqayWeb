LOCALPATH=$(pwd)

echo "$LOCALPATH"

sudo apt-get install apache2
sudo apt-get install zlib1g-dev flex bison libreadline-dev
sudo apt-get install hunspell
sudo apt-get install libio-captureoutput-perl
sudo apt-get install libconfig-inifiles-perl
sudo apt-get install libdatetime-perl
sudo apt-get install libxml-writer-perl
sudo apt-get install libmoose-perl
sudo apt-get install default-jre

sudo mkdir -p /var/www/allinqillqay.localhost/public_html

sudo chown -R $USER:$USER /var/www/allinqillqay.localhost/public_html
sudo chmod -R 755 /var/www

sudo ln -sv $LOCALPATH/ClientSide/ckeditor \
/var/www/allinqillqay.localhost/public_html/ckeditor

sudo ln -sv $LOCALPATH/ServerSide/WebSpellChecker/spellcheck31 \
/var/www/allinqillqay.localhost/public_html/spellcheck31

cd $LOCALPATH/ServerSide/Hinantin/cgi-bin 
sudo cp -a spellcheck31 /usr/lib/cgi-bin/
cd /usr/lib/cgi-bin/spellcheck31/script/
sudo chmod o+x ssrv.cgi

cd $LOCALPATH/ServerSide/SQUOIA/foma/
make
sudo make install
sudo cp suggestions /usr/bin/
sudo chmod +x /usr/bin/suggestions

sudo mkdir -p /usr/share/squoia/

# Cuzco Quechua
cd $LOCALPATH/ServerSide/SQUOIA
tar -xvf squoiaSpellCheckCuzco.tar
cd spellcheckCuzco_foma
foma -f spellcheck.foma
sudo cp spellcheck.fst /usr/share/squoia/

# Southern Unified Quechua
cd $LOCALPATH/ServerSide/SQUOIA
tar -xvf squoiaSpellCheckUnificado.tar
cd spellcheckUnificado_foma
foma -f spellcheckUnificado.foma
cp spellcheckUnificado.fst /usr/share/squoia/

sudo cp /etc/apache2/sites-available/default /etc/apache2/sites-available/allinqillqay.localhost
sudo nano /etc/apache2/sites-available/allinqillqay.localhost
