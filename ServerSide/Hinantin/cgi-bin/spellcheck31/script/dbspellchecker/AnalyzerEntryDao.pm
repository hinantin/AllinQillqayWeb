#!/usr/bin/perl
package AnalyzerEntryDao;

use strict;
use warnings;
use Encode qw(encode_utf8);

use DatabaseFactory;
use CAnalyzerEntry;

sub new {
   my $self = {};
   my $Df = new DatabaseFactory();
   $self->{Db} = $Df->CreateDataBase();
   bless($self);
   return $self;
}

sub Save {
   my $self = shift;
   my $oAnalyzerEntry = undef;
   ($oAnalyzerEntry) = @_;
   my $SQLSTRING = "INSERT INTO `diccionario_analyzer` (`Descripcion`, `Tipo`) VALUES ('" . $oAnalyzerEntry->getDescripcion() . "', '" . $oAnalyzerEntry->getTipo() . "');\n";
   #print $SQLSTRING;
   my $st = $self->{Db}->prepare($SQLSTRING);
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
}

sub Update {
   my $OID = undef;
   my $self = shift;
   my $oAnalyzerEntry = undef;
   ($oAnalyzerEntry) = @_;
   my $SQLSTRING = "CALL SaveAnalyzerEntry('$oAnalyzerEntry->getOID()', '$oAnalyzerEntry->getDescripcion()', '$oAnalyzerEntry->getTipo()');";
   #print $SQLSTRING;
   my $st = $self->{Db}->prepare($SQLSTRING);
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
   ($OID) = $st->fetchrow_array();
   return $OID;
}

sub Delete {
   my $self = shift;
   my $OID = undef;
   ($OID) = @_;
   my $st = $self->{Db}->prepare("delete from diccionario where 'OID' = $OID");
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
}

sub Exist {
   my $self = shift;
   my $OID = undef;
   my $Descripcion = undef;
   my $Tipo = undef;

   ($OID) = @_;
   my $st = $self->{Db}->prepare("select * from diccionario where 'OID' = $OID");
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
   my $oAnalyzerEntry = undef;
   while (($OID,$Descripcion,$Tipo) = $st->fetchrow_array) {
	   $OID = encode_utf8($OID);
	   $Descripcion = encode_utf8($Descripcion);
	   $Tipo = encode_utf8($Tipo);   
	   $oAnalyzerEntry = new CAnalyzerEntry($OID,$Descripcion,$Tipo);
	   return $oAnalyzerEntry; 
   }
   return $oAnalyzerEntry;
}

sub List {
   my $self = shift;
   my $OID = undef;
   my $Descripcion = undef;
   my $Tipo = undef;
   
   my $st = $self->{Db}->prepare("select * from diccionario");
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
   my @list;
   my $oAnalyzerEntry = undef;
   while (($OID,$Descripcion,$Tipo) = $st->fetchrow_array) {
           $OID = encode_utf8($OID);
           $Descripcion = encode_utf8($Descripcion);
           $Tipo = encode_utf8($Tipo);
           $oAnalyzerEntry = new CAnalyzerEntry($OID,$Descripcion,$Tipo);
           push(@list, $oAnalyzerEntry);
   }
   return @list;
}

sub ExistDescription {
   my $self = shift;
   my $OID = undef;
   my $Descripcion = undef;
   my $Tipo = undef;

   ($Descripcion) = @_;
   my $st = $self->{Db}->prepare("select * from `diccionario` where `Descripcion` = $Descripcion");
   $st->execute or die "SQL Error: $self->{Db}::errstr\n";
   my $oAnalyzerEntry = undef;
   while (($OID,$Descripcion,$Tipo) = $st->fetchrow_array) {
           $OID = encode_utf8($OID);
           $Descripcion = encode_utf8($Descripcion);
           $Tipo = encode_utf8($Tipo);
           $oAnalyzerEntry = new CAnalyzerEntry($OID,$Descripcion,$Tipo);
           return $oAnalyzerEntry;
   }
   return $oAnalyzerEntry;
}
1;
