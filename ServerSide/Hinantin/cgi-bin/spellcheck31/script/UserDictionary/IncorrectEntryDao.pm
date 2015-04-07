#!/usr/bin/perl
package IncorrectEntryDao;

use strict;
use warnings;
use Encode qw(encode_utf8);

use DatabaseFactory;
use CIncorrectEntry;

sub new {
   my $self = {};
   my $Df = new DatabaseFactory();
   $self->{Db} = $Df->CreateDataBase();
   bless($self);
   return $self;
}

sub Save {
   my $self = shift;
   my $oIncorrectEntry = undef;
   my $cpIncorrectEntryId = undef;
   my $cpEntry = undef;
   my $cpIsCorrect = undef;
   my $cpFrecuency = undef;
   my $cpSLang = undef;
   my $cpDate = undef;
   my $cpUser = undef;
   ($oIncorrectEntry) = @_;
   $cpIncorrectEntryId = $oIncorrectEntry->getcpIncorrectEntryId();
   $cpEntry = $oIncorrectEntry->getcpEntry();
   $cpIsCorrect = $oIncorrectEntry->getcpIsCorrect();
   $cpFrecuency = $oIncorrectEntry->getcpFrecuency();
   $cpSLang = $oIncorrectEntry->getcpSLang();
   $cpDate = $oIncorrectEntry->getcpDate();
   $cpUser = $oIncorrectEntry->getcpUser();
   my $SQLSTRING = "CALL `SaveIncorrectEntry` ($cpIncorrectEntryId, '$cpEntry', '$cpIsCorrect', $cpFrecuency, '$cpSLang', '$cpDate', '$cpUser');";
   #print $SQLSTRING;
   my $st = $self->{Db}->prepare($SQLSTRING);
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
}
1;
