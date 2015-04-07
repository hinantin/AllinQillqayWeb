#!/usr/bin/perl
package CorrectEntryDao;

use strict;
use warnings;
use Encode qw(encode_utf8);

use DatabaseFactory;
use CCorrectEntry;

sub new {
   my $self = {};
   my $Df = new DatabaseFactory();
   $self->{Db} = $Df->CreateDataBase();
   bless($self);
   return $self;
}

sub Save {
   my $self = shift;
   my $oCorrectEntry = undef;   
   my $cpCorrectEntryId = undef;
   my $cpCorrectEntry = undef;
   my $cpIncorrectEntryId = undef;
   my $cpIncomingWord = undef;
   my $cpFrecuency = undef;
   my $cpUser = undef;
   my $cpSLang = undef;
   my $cpRegistrationDate = undef;
   ($oCorrectEntry) = @_;
   $cpCorrectEntryId = $oCorrectEntry->getcpCorrectEntryId();
   $cpCorrectEntry = $oCorrectEntry->getcpCorrectEntry();
   $cpIncorrectEntryId = $oCorrectEntry->getcpIncorrectEntryId();
   $cpIncomingWord = $oCorrectEntry->getcpIncomingWord();
   $cpFrecuency = $oCorrectEntry->getcpFrecuency();
   $cpUser = $oCorrectEntry->getcpUser();
   $cpSLang = $oCorrectEntry->getcpSLang();
   $cpRegistrationDate = $oCorrectEntry->getcpRegistrationDate();   
   my $SQLSTRING = "CALL `sp_SaveCorrectEntry` (NULL, NULL, NULL, '$cpIncomingWord', NULL, NULL, NULL, NOW());";
   #print $SQLSTRING;
   my $st = $self->{Db}->prepare($SQLSTRING);
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
}
1;
