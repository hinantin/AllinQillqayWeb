#!/usr/bin/perl
package CErrorCorpus;

use strict;
use warnings;
use Encode qw(encode_utf8);

use XmlDatabaseFactory;
use CIncorrectEntry;

sub new {
   my $self = {};
   my $Xdf = new XmlDatabaseFactory();
   $self->{Xdf} = $Xdf->CreateSessionXmlDatabase();
   bless($self);
   return $self;
}

Add {
  #reading file
  open(FILE, '/usr/lib/cgi-bin/spellcheck31/script/ErrorCorpus/HNTErrorCorpus_Add.xq') or die "Can't read file 'filename' [$!]\n";  
  local $/;
  my $input = <FILE>; 
  close (FILE);
  
  # create query instance
  my $query = $self->{Xdf}->query($input);
  my $str = $query->execute();
  # close query
  $query->close();
  # close session
  $self->{Xdf}->close();
}
1;
