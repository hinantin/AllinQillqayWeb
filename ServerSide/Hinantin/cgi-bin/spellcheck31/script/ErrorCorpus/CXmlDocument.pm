#!/usr/bin/perl
package CXmlDocument;

use BaseXClient;
use XML::Writer;
use IO::File;
use CErrorCorpus;

sub new {
   my $self = {};
   my $Ec = new CErrorCorpus();
   $self->{Ec} = $Ec;
   bless($self);
   return $self;
}

Add {
  my $text = "a, b, c, d";
  my $spellcheck_engine = "bol_myspell";
  my $spellcheck_engine_version = "v1.5-beta.1";
  my $path = "/home/richard/Documents/AllinQillqayWeb/ServerSide/Hinantin/cgi-bin/spellcheck31/script/ErrorCorpus";
  my ($sec, $min, $hour, $mday, $mon, $year) = localtime();
  my $timestamp = sprintf("%04d%02d%02d%02d%02d%02d",$year+1900,$mon+1,$mday,$hour,$min,$sec);
  my $filename = "doc_$timestamp.xml";
  my $output = IO::File->new(">$filename");

  my $writer = XML::Writer->new(OUTPUT => $output);
  $writer->xmlDecl("UTF-8");
  $writer->startTag("document", "id" => "doc_$timestamp");
  $writer->startTag("text");
  $writer->cdata($text);
  $writer->endTag("text");
  $writer->startTag("check_spelling", "engine_id" => $spellcheck_engine, "engine_version" => $spellcheck_engine_version);
    $writer->startTag("entry", "type" => "misspelling", "id" => "1");
    $writer->startTag("word"); $writer->characters("wasii"); $writer->endTag("word");
    $writer->startTag("position"); $writer->characters("11"); $writer->endTag("position");
    $writer->startTag("length"); $writer->characters("6"); $writer->endTag("length");
    $writer->startTag("suggestions"); 
      $writer->startTag("suggestion"); $writer->characters("wasiy"); $writer->endTag("suggestion");
    $writer->endTag("suggestions");
    $writer->endTag("entry");
  $writer->endTag("check_spelling");
  $writer->endTag("document");
  $writer->end();
  $output->close();

  eval {
    $self->{Ec}->Add($path,$filename)
  };
  # print exception
  print $@ if $@;

}
1;
