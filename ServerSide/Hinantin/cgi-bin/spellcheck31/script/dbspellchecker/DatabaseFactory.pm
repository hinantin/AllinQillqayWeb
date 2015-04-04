#!/usr/bin/perl
package DatabaseFactory;

use DBI;
use Config::IniFiles;

sub new {
	my $self = {};
	my $CONFIG =
	  Config::IniFiles->new( -file =>
		  "/usr/lib/cgi-bin/spellcheck31/script/dbspellchecker/ConfigFile.ini"
	  );
	$self->{PLATFORM} = $CONFIG->val( 'PRODUCTION_MYSQL_HNTUserDictionary', 'PLATFORM' );
	$self->{DATABASE} = $CONFIG->val( 'PRODUCTION_MYSQL_HNTUserDictionary', 'DATABASE' );
	$self->{HOST}     = $CONFIG->val( 'PRODUCTION_MYSQL_HNTUserDictionary', 'HOST' );
	$self->{PORT}     = $CONFIG->val( 'PRODUCTION_MYSQL_HNTUserDictionary', 'PORT' );
	$self->{USER}     = $CONFIG->val( 'PRODUCTION_MYSQL_HNTUserDictionary', 'USER' );
	$self->{PASSWORD} = $CONFIG->val( 'PRODUCTION_MYSQL_HNTUserDictionary', 'PASSWORD' );
	bless($self);
	return $self;
}

sub CreateDataBase {
	my $self = shift;
	return DBI->connect(
		"dbi:$self->{PLATFORM}:$self->{DATABASE}:$self->{HOST}:$self->{PORT}",
		$self->{USER}, 
		$self->{PASSWORD},
		{
        	mysql_enable_utf8 => 1,
     	}   
	)
	or die "Connection Error: $DBI::errstr\n";
}
1;
