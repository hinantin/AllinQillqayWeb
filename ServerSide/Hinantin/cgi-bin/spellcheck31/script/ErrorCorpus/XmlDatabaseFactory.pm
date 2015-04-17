#!/usr/bin/perl
package XmlDatabaseFactory;

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
	$self->{PLATFORM} = $CONFIG->val( 'PRODUCTION_BASEX_HNTErrorCorpus', 'PLATFORM' );
	$self->{DATABASE} = $CONFIG->val( 'PRODUCTION_BASEX_HNTErrorCorpus', 'DATABASE' );
	$self->{HOST}     = $CONFIG->val( 'PRODUCTION_BASEX_HNTErrorCorpus', 'HOST' );
	$self->{PORT}     = $CONFIG->val( 'PRODUCTION_BASEX_HNTErrorCorpus', 'PORT' );
	$self->{USER}     = $CONFIG->val( 'PRODUCTION_BASEX_HNTErrorCorpus', 'USER' );
	$self->{PASSWORD} = $CONFIG->val( 'PRODUCTION_BASEX_HNTErrorCorpus', 'PASSWORD' );
	bless($self);
	return $self;
}

sub CreateSessionXmlDatabase {
	my $self = shift;
	return Session->new(
		$self->{PLATFORM}, $self->{PORT}, $self->{USER}, $self->{PASSWORD}
	)
	or die "Connection Error::errstr\n";
}

sub getDatabase {
	my( $self ) = @_;
	return $self->{DATABASE};
}
1;
