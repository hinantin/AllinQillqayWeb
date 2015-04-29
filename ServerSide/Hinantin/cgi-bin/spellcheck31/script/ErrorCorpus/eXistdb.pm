#!/usr/bin/perl
package eXistdb;

use RPC::XML;
use RPC::XML::Client;
use Config::IniFiles;
use warnings;
use strict;
$RPC::XML::ENCODING = 'utf-8';

sub new {
	my $self = {};
	my $CONFIG =
	  Config::IniFiles->new( -file =>
		  "/usr/lib/cgi-bin/spellcheck31/script/ConfigFile.ini"
	  );
	$self->{PLATFORM} = $CONFIG->val( 'PRODUCTION_EXISTDB_HNTErrorCorpus', 'PLATFORM' );
	$self->{DATABASE} = $CONFIG->val( 'PRODUCTION_EXISTDB_HNTErrorCorpus', 'DATABASE' );
	$self->{HOST}     = $CONFIG->val( 'PRODUCTION_EXISTDB_HNTErrorCorpus', 'HOST' );
	$self->{PORT}     = $CONFIG->val( 'PRODUCTION_EXISTDB_HNTErrorCorpus', 'PORT' );
	$self->{USER}     = $CONFIG->val( 'PRODUCTION_EXISTDB_HNTErrorCorpus', 'USER' );
	$self->{PASSWORD} = $CONFIG->val( 'PRODUCTION_EXISTDB_HNTErrorCorpus', 'PASSWORD' );
	bless($self);
	return $self;
}

sub SendRequestToXmlDatabase {
	my $self = shift;
	my ( $query ) = @_;
	my $pw = $self->{PASSWORD};
	my $us = $self->{USER};
	my $ht = $self->{HOST};
	my $pt = $self->{PORT};
	my $ptf = $self->{PLATFORM};
	my $URL = "http://$pw:$us\@$ht:$pt/$ptf/xmlrpc";
	#print $URL;
	# connecting to $URL...
	my $client = new RPC::XML::Client $URL;
	# Output options
	my $options = RPC::XML::struct->new('indent' => 'yes', 'highlight-matches' => 'none');
	my $req = RPC::XML::request->new("query", $query, 20, 1, $options);
	my $response = $client->send_request($req);
	if($response->is_fault) {
		die "An error occurred: " . $response->string . "\n";
	}
	my $result = $response->value;
	return $result;
}

sub getDatabase {
	my( $self ) = @_;
	return $self->{DATABASE};
}
1;
