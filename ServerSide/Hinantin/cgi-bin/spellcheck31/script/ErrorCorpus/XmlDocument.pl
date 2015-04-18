#!/usr/bin/perl
package CXmlDocument;

use BaseXClient;
use XML::Writer;
use IO::File;
use CErrorCorpus;
use lib '/home/richard/Documents/AllinQillqayWeb/ServerSide/Hinantin/cgi-bin/spellcheck31/script';
use CSpellChecker;

  # Input variables
  my $spellcheck_engine = "bol_myspell";
  my $spellcheck_engine_version = "v1.5-beta.1";
  my $text = "wasi, wasiiy, qan, d";
  my $path = "/home/richard/Documents/AllinQillqayWeb/ServerSide/Hinantin/cgi-bin/spellcheck31/script/ErrorCorpus";
  my $squoiapath = "/usr/share/squoia";
  my $slang = "cuz_simple_foma";
  my $object = CSpellChecker->new( "$squoiapath/spellcheck.fst", $slang, "cmd" );

  my @listWords = ();
  @listWords = split( ',', $text );

  my ($sec, $min, $hour, $mday, $mon, $year) = localtime();
  my $timestamp = sprintf("%04d%02d%02d%02d%02d%02d",$year+1900,$mon+1,$mday,$hour,$min,$sec);
  my $filename = "doc_$timestamp.xml";
  print "$path/$filename\n";
  my $output = IO::File->new(">$filename");

  my $writer = XML::Writer->new(OUTPUT => $output);
  $writer->xmlDecl("UTF-8");
  $writer->startTag("document", "id" => "doc_$timestamp");
  $writer->startTag("text");
  $writer->cdata($text);
  $writer->endTag("text");
  $writer->startTag("check_spelling", "engine_id" => $spellcheck_engine, "engine_version" => $spellcheck_engine_version);
  my $index = 0;
  foreach $word (@listWords) {
    $index = $index + 1;
    $word =~ s/^\s+|\s+$//g; # trimming string
    $correct = $object->SpellCheck($word);
    if (not $correct) { # the word is misspelled
      $writer->startTag("entry", "type" => "misspelling", "id" => $index);
      $writer->startTag("word"); $writer->characters($word); $writer->endTag("word");
      #$writer->startTag("position"); $writer->characters("11"); $writer->endTag("position");
      $writer->startTag("length"); $writer->characters(length($word)); $writer->endTag("length");
      $writer->startTag("suggestions"); 
        my $suggestions = $object->Suggestions($word);
        print $suggestions;
        $suggestions = substr($suggestions , 0, length($suggestions) - 2);
        my @listSuggestions = ();
        @listSuggestions = split( ',', $suggestions );
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
  $output->close();

eval {
   my $Ec = new CErrorCorpus();
   $Ec->Add($path,$filename);
   unlink "$path/$filename";
};

# print exception
print $@ if $@;
