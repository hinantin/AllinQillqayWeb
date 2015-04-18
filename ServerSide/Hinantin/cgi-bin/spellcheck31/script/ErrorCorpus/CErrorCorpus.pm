#!/usr/bin/perl
package CErrorCorpus;

use XmlDatabaseFactory;

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
1;
