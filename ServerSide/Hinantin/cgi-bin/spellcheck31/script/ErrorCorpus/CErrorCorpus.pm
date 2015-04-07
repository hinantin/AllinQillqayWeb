#!/usr/bin/perl
package CErrorCorpus;

use BaseXClient;
use Time::HiRes;
use Config::IniFiles;
use warnings;
use strict;

sub new {
	my $self = {};
	my $CONFIG =
	  Config::IniFiles->new( -file =>
		  "/usr/lib/cgi-bin/spellcheck31/script/ConfigFile.ini"
	  );
	$self->{PLATFORM} = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'PLATFORM' );
	$self->{DATABASE} = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'DATABASE' );
	$self->{HOST}     = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'HOST' );
	$self->{PORT}     = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'PORT' );
	$self->{USER}     = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'USER' );
	$self->{PASSWORD} = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'PASSWORD' );
	bless($self);
	return $self;
}

Add {
  # create session
  my $session = Session->new($self->{PLATFORM}, $self->{PORT}, $self->{USER}, $self->{PASSWORD});

  #reading file
  open(FILE, '/usr/lib/cgi-bin/spellcheck31/script/ErrorCorpus/HNTErrorCorpus_Add.xq') or die "Can't read file 'filename' [$!]\n";  
  local $/;
  my $input = <FILE>; 
  close (FILE);
  
  # create query instance
  my $query = $session->query($input);
  my $str = $query->execute();
  # close query
  $query->close();
  # close session
  $session->close();
}
1;
