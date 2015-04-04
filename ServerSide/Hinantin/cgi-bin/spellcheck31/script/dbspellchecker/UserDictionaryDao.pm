#!/usr/bin/perl
package UserDictionaryDao;

use strict;
use warnings;
use Encode qw(encode_utf8);

use DatabaseFactory;
use CUserDictionary;

sub new {
   my $self = {};
   my $Df = new DatabaseFactory();
   $self->{Db} = $Df->CreateDataBase();
   bless($self);
   return $self;
}

sub Save {
   my $self = shift;
   my $oUserDictionary = undef;
   my $cpUserDictionaryId = undef;
   my $cpSLang = undef;
   my $cpEntry = undef;
   my $cpDate = undef;
   my $cpUser = undef;
   ($oUserDictionary) = @_;
   $cpUserDictionaryId = $oUserDictionary->getcpUserDictionaryId();
   $cpSLang = $oUserDictionary->getcpSLang();
   $cpEntry = $oUserDictionary->getcpEntry();
   $cpDate = $oUserDictionary->getcpDate();
   $cpUser = $oUserDictionary->getcpUser();
   my $SQLSTRING = "CALL `SaveUserDictionary` ($cpUserDictionaryId, '$cpSLang', '$cpEntry', '$cpDate', '$cpUser');";
   #print $SQLSTRING;
   my $st = $self->{Db}->prepare($SQLSTRING);
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
}
1;
