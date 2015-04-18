#!/usr/bin/perl
#package CXmlDocument;

use BaseXClient;
use XML::Writer;
use IO::File;
use CErrorCorpus;
use lib '/home/richard/Documents/AllinQillqayWeb/ServerSide/Hinantin/cgi-bin/spellcheck31/script';
use SpellCheckBase;
#use SpellChecker;
#use CXmlDocument;

eval {
  # Input variables
  my $text = "wasi, wasiiy, qan, d, manamm";
  my $tmpdir = "/usr/lib/cgi-bin/spellcheck31/script/ErrorCorpus/tmp/";
  my $squoiapath = "/usr/share/squoia";
  my $engine = "cuz_simple_foma";
  my $version = "v1.0-beta.1";
  #my $object = CSpellChecker->new( "$squoiapath/spellcheck.fst", $engine, $version, "cmd" );
  #my $xmldoc = new CXmlDocument($object);
  #my ($path, $filename) = $xmldoc->CreateXmlFile($text, $tmpdir);
  #$xmldoc->Add($path, $filename);
  #unlink "$path/$filename";
};

# print exception
print $@ if $@;
