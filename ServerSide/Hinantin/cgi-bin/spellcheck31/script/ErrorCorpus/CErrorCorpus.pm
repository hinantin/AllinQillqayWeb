#!/usr/bin/perl
package CErrorCorpus;

use XmlDatabaseFactory;
use eXistdb;

sub new {
    my $class = shift;
    my $self = {
        _Session => shift,
        _DatabaseName => shift
    };
    bless $self, $class;
    return $self;
}

sub Add {
  my ( $self, $filename, $xmlcontent ) = @_; 
  # create session
  my $Xdf = new XmlDatabaseFactory();
  my $session = $Xdf->CreateSessionXmlDatabase();
  my $databasename = $Xdf->getDatabase();
  # create empty database
  $session->execute("OPEN $databasename");
  # add document
  $session->add($filename, $xmlcontent);
  # close session
  $session->close();
}

sub AddToeXistdbCollection {
  my ( $self, $filename, $xmlcontent, $engine ) = @_; 
  my $Xdf = new eXistdb();
  my $collection = $Xdf->getDatabase();
  $query = <<END;
xquery version "3.0";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
declare variable \$filename := '$filename';
declare variable \$record := '';

let \$record := fn:parse-xml('$xmlcontent')
for \$target in ('/db/$collection/$engine')
  return xmldb:store(\$target, \$filename, \$record)
END
  $Xdf->SendRequestToXmlDatabase($query);
}
1;
