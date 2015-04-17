#!/usr/bin/perl

use BaseXClient;
use XML::Writer;
use IO::File;

  my $text = "
This is an exampl of a sentence with two mispelled words.
Just type text with to see how it works.
";
  my $spellcheck_engine = "bol_myspell";
  my $spellcheck_engine_version = "v1.5-beta.1";
  my $path = "/home/richard/Documents/AllinQillqayWeb/ServerSide/Hinantin/cgi-bin/spellcheck31/script/ErrorCorpus";
  my ($sec, $min, $hour, $mday, $mon, $year) = localtime();
  my $timestamp = sprintf("%04d%02d%02d%02d%02d%02d",$year+1900,$mon+1,$mday,$hour,$min,$sec);
  
  my $output = IO::File->new(">doc_$timestamp.xml");

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

open(FILE, 'HNTErrorCorpus_Add.xq') or die "Can't read file 'filename' [$!]\n";  
local $/;
$document = <FILE>;
close (FILE);
print $document;

eval {

  # create session
  my $session = Session->new("localhost", 1984, "admin", "admin");

  # create empty database
  $session->execute("OPEN DB database");
  print $session->info()."\n";
  
  # add document
  $session->execute("ADD $path/doc_$timestamp.xml");
  print $session->info()."\n";
  
  # run query on database
  print $session->execute("xquery collection('database')")."\n";
  
  # drop database
  $session->execute("DROP DB database");
  
  # close session
  $session->close();
};

# print exception
print $@ if $@;
