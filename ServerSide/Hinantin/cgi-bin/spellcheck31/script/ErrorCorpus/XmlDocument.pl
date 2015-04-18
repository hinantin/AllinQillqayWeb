#!/usr/bin/perl
#package CXmlDocument;

use BaseXClient;
use XML::Writer;
use IO::File;
use CErrorCorpus;
use lib 'usr/lib/cgi-bin/spellcheck31/script';
use SpellCheckBase;
#use SpellChecker;
use CXmlDocument;

eval {
  # Input variables
  my $text = "wasi, wasiiy, qan, ñawi, manamm";
  my $squoiapath = "/usr/share/squoia";
  my $engine = "cuz_simple_foma";
  my $version = "v1.0-beta.1";
  my $object = SpellCheckFiniteStateCmd->new(
    FstFile => "$squoiapath/spellcheck.fst",
    EngineName => $engine,
    EngineVersion => $version,
    Type => "cmd",
  );
  #my $object = CSpellChecker->new( "$squoiapath/spellcheck.fst", $engine, $version, "cmd" );
  my $xmldoc = new CXmlDocument($object);
  my ($filename, $xmlcontent) = $xmldoc->CreateXmlFile($text);
  $xmldoc->Add($filename, $xmlcontent);
  #unlink "$path/$filename";
};

# print exception
print $@ if $@;
