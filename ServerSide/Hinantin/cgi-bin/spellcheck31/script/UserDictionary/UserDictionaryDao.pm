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
   my ($oUserDictionary) = @_;
   my $cpUserDictionaryId = $oUserDictionary->cpUserDictionaryId();
   my $cpSLang = $oUserDictionary->cpSLang();
   my $cpEntry = $oUserDictionary->cpEntry();
   my $cpDate = $oUserDictionary->cpDate();
   my $cpUser = $oUserDictionary->cpUser();
   my $SQLSTRING = "CALL `SaveUserDictionaryEntry` ($cpUserDictionaryId, '$cpSLang', '$cpEntry', NOW(), '$cpUser');";
   my $st = $self->{Db}->prepare($SQLSTRING);
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
}

sub Delete {
   my $self = shift;
   my ($oUserDictionary) = @_;
   my $cpSLang = $oUserDictionary->cpSLang();
   my $cpEntry = $oUserDictionary->cpEntry();
   my $SQLSTRING = "CALL `DeleteUserDictionaryEntry` ('$cpSLang', '$cpEntry');";
   my $st = $self->{Db}->prepare($SQLSTRING);
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
}

sub DoesUserDictionaryContainEntry {
   my $self = shift;
   my ($oUserDictionary) = @_;
   my $cpSLang = $oUserDictionary->cpSLang();
   my $cpEntry = $oUserDictionary->cpEntry();
   my $SQLSTRING = "SELECT `DoesUserDictionaryContainEntry` ('$cpSLang', '$cpEntry') AS 'EXIST';";
   my $exist = $self->{Db}->selectrow_array($SQLSTRING);
   return $exist;
}
1;
