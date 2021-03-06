#!/usr/bin/perl
package CXmlDocument;

use strict;
use warnings;
use BaseXClient;
use XML::Writer;
use IO::File;
use CErrorCorpus;
use lib 'usr/lib/cgi-bin/spellcheck31/script';
use SpellCheckBase;

sub new {
  my $class = shift;
  my ($Sc) = @_;
  my $Ec = new CErrorCorpus();
  my $self = { Ec => $Ec, Sc => $Sc };
  bless $self, $class;
  return $self;
}

sub CreateXmlFile {
  my $self = shift;
  my ( $text ) = @_;
  my $spellcheck_engine = $self->{Sc}->EngineName();
  my $spellcheck_engine_version = $self->{Sc}->EngineVersion();

  my @listWords = ();
  @listWords = split( ',', $text );
  # The code name for the file is a simple timestamp
  my ($sec, $min, $hour, $mday, $mon, $year) = localtime();
  my $timestamp = sprintf("%04d%02d%02d%02d%02d%02d",$year+1900,$mon+1,$mday,$hour,$min,$sec);
  my $filename = "doc_$timestamp.xml";
  my $s;
  # We used the Perl XML Writer to create the XML structure
  my $writer = XML::Writer->new(OUTPUT => \$s);
  $writer->xmlDecl("UTF-8");
  $writer->startTag("document", "id" => "doc_$timestamp");
  $writer->startTag("text");
  $writer->cdata($text);
  $writer->endTag("text");
  $writer->startTag("check_spelling", "engine_id" => $spellcheck_engine, "engine_version" => $spellcheck_engine_version);
  my $index = 0;
  my $word = "";
  foreach $word (@listWords) {
    $index = $index + 1;
    $word =~ s/^\s+|\s+$//g; # trimming string
    my $correct = $self->{Sc}->SpellCheck($word);
    if (not $correct) { # the word is misspelled
      $writer->startTag("entry", "type" => "misspelling", "id" => $index);
      $writer->startTag("word"); $writer->characters($word); $writer->endTag("word");
      #$writer->startTag("position"); $writer->characters("11"); $writer->endTag("position");
      $writer->startTag("length"); $writer->characters(length($word)); $writer->endTag("length");
      $writer->startTag("suggestions"); 
        my $suggestions = $self->{Sc}->getSuggestions($word);
        $word =~ s/^\s+|\s+$//g; # trimming string
        $word =~ s/,$//g; # trimming string
        # Listing the suggestions
        my @listSuggestions = ();
        @listSuggestions = split( ',', $suggestions );
        my $suggestion = "";
        foreach $suggestion (@listSuggestions) {
          $suggestion =~ s/^\s+|\s+$//g; # trimming string
          $suggestion =~ s/"//g; # deleting the double quotes
          $writer->startTag("suggestion"); $writer->characters($suggestion); $writer->endTag("suggestion");
        }
      $writer->endTag("suggestions");
      $writer->endTag("entry");
    }
    else {
      $writer->startTag("entry", "type" => "spelled-correctly", "id" => $index);
      $writer->startTag("word"); $writer->characters($word); $writer->endTag("word");
      $writer->endTag("entry");
    }
  }
  $writer->endTag("check_spelling");
  $writer->endTag("document");
  $writer->end();
  return ($filename, $s);
}

sub Add
{
  my $self = shift;
  my ( $filename, $xmlcontent ) = @_;
  $self->{Ec}->Add($filename, $xmlcontent);
}

sub AddToeXistdbCollection {
  my $self = shift;
  my ( $filename, $xmlcontent, $engine ) = @_;
  $xmlcontent =~ s/'/''/g;
  $self->{Ec}->AddToeXistdbCollection($filename, $xmlcontent, $engine);
}
1;
