#!/usr/bin/perl

#    Allin Qillqay is a Free On-Line Web spell checking system which uses the CKEditor, 
#    a well-known HTML text processor and its spell-check-as-you-type (SCAYT) add-on to 
#    provide access to the different spellchecking technologies that have been developed 
#    for the Quechua language.
#
#    Copyright (C) 2018  Hinantin Software
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#    Richard Castro, e-mail: rcastro AT hinant.in


use File::Temp qw/ tempdir /;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use lib '/usr/lib/cgi-bin/spellcheck31/script';
use lib '/usr/lib/cgi-bin/spellcheck31/script/ErrorCorpus';
use lib '/usr/lib/cgi-bin/spellcheck31/script/UserDictionary';
use SpellCheckBase;
my $query = new CGI();
print $query -> header(
-type => 'text/javascript; charset=UTF-8',
);
use Encode;
my $squoiapath = "/usr/share/squoia";
my $hinantinpath = "/usr/share/NEWLANGUAGE";

# First command
my $cmd = $query->param('cmd');

my $callback = undef;
my $customerid = undef;
my $run_mode = undef;
my $slang = undef;
my $format = undef;
my $out_type = undef;
my $text = undef;
my $version = undef;
my $custom_dictionary = undef;
my $user_dictionary = undef;
my $user_wordlist = undef;

if ($cmd eq "get_lang_list") { 
  $callback = $query->param('callback');
  $customerid = $query->param('customerid');
  $run_mode = $query->param('run_mode');
  $slang = $query->param('slang');
  print $callback . '({langList:{ltr: {"cuz_simple_foma" : "Quechua Cusqueño", "uni_simple_foma" : "Quechua Sureño", "uni_extended_foma" : "Quechua Sureño Extendido", "bol_myspell" : "Quechua Boliviano", "ec_hunspell" : "Kichwa Ecuatoriano", "newlanguage_foma" : "NEW LANGUAGE"},rtl: {}},verLang : 6})';
}
elsif ($cmd eq "getbanner") { 
  $callback = $query->param('callback');
  $customerid = $query->param('customerid');
  $run_mode = $query->param('run_mode');
  $format = $query->param('format');
  print $callback . '({ banner : false } )';
}
elsif ($cmd eq "user_dictionary") {
  # ####################### #
  #      User Dictionary    #
  # ####################### #
  $callback = $query->param('callback');
  $customerid = $query->param('customerid');
  $run_mode = $query->param('run_mode');
  $format = $query->param('format');
  my $action = $query->param('action');
  $user_wordlist = $query->param('user_wordlist');
  # create
  if ($action eq "create") {
    my $name = $query->param('name');
    my $wordlist = $query->param('wordlist');
    my $object = undef;
    $object = SpellCheckBase->new(
      FstFile => "",
      EngineName => "$name",
      EngineVersion => "$v",
      Type => "cmd",
    );
    # user dictionary
    if ($wordlist ne "") {
      my @listUserEntries = ();
      my $entry = undef;
      @listUserEntries = split( ',', $wordlist );
      foreach $entry (@listUserEntries) {
        $entry =~ s/^\s+|\s+$//g; # trimming string
        $object->AddEntryUserDictionary($entry);
      }
    }
    print $callback . "({name: \"$name\", action: \"$action\", wordlist: []})";
  }
  elsif ($action eq "rename") {
    my $name = $query->param('name');
    my $new_name = $query->param("new_name");
    my $v = $query->param('v');
    print $callback . "({name: \"$new_name\", action: \"$action\", wordlist: []})";
  }
  elsif ($action eq "delete") {
    my $name = $query->param('name');
    my $v = $query->param('v');
    print $callback . "({name: \"$name\", action: \"$action\", wordlist: []})";
  }
  else {}
}
elsif ($cmd eq "check_spelling") { 
  $callback = $query->param('callback');
  $customerid = $query->param('customerid');
  $format = $query->param('format');
  $out_type = $query->param('out_type');
  $run_mode = $query->param('run_mode');
  $slang = $query->param('slang');
  $text = $query->param('text');
  $version = $query->param('version');
  $user_wordlist = $query->param('user_wordlist');
  # ########################
  # Local variables 
  # ########################
  my @listWords = ();
  my $object = undef;
  my $spellcheck = "";
  my $result = "";
  
  @listWords = split( ',', $text );
  if ($slang eq "uni_simple_foma") {
    $object = SpellCheckFiniteStateCmd->new(
    FstFile => "$squoiapath/spellcheckUnificado.fst",
    EngineName => "$slang",
    EngineVersion => "v1.0-beta.1",
    Type => "cmd",
    );
  }
  elsif ($slang eq "cuz_simple_foma") {
    $object = SpellCheckFiniteStateCmd->new(
    FstFile => "$squoiapath/spellcheck.fst",
    EngineName => "$slang",
    EngineVersion => "v1.0-beta.1",
    Type => "cmd",
    );
  }
  elsif ($slang eq "uni_extended_foma") {
    $object = SpellCheckFiniteStateCTcp->new(
    FstFile => "",
    EngineName => "$slang",
    EngineVersion => "v1.0-beta.2",
    Type => "port",
    PeerHost => '127.0.0.1',
    PeerPort => '8888',
    Proto => 'tcp',
    );
  }
  elsif ($slang eq "bol_myspell") {
    #$object = SpellCheckFiniteStateNSpell->new(
    #FstFile => "",
    #EngineName => "$slang",
    #EngineVersion => "v1.0-beta.1",
    #Type => "cmd",
    #Lang => "quh_BO",
    #);
    $object = SpellCheckFiniteStateCTcp->new(
    FstFile => "",
    EngineName => "$slang",
    EngineVersion => "v1.0-beta.3",
    Type => "port",
    PeerHost => '127.0.0.1',
    PeerPort => '8890',
    Proto => 'tcp',
    );
  }
  elsif ($slang eq "newlanguage_foma") {
    $object = SpellCheckAshaninkaMorph->new(
    FstFile => "$hinantinpath/error_correction.fst",
    EngineName => "$slang",
    EngineVersion => "v1.0-beta.1",
    Type => "cmd",
    PeerHostErrorDetection => '127.0.0.1',
    PeerPortErrorDetection => '7890',
    PeerHostErrorCorrection => '127.0.0.1',
    PeerPortErrorCorrection => '7891',
    Proto => 'tcp',
    );
  }
  else { # ec_hunspell
    #$object = SpellCheckFiniteStateNSpell->new(
    #FstFile => "",
    #EngineName => "$slang",
    #EngineVersion => "v1.0-beta.1",
    #Type => "cmd",
    #Lang => "qu_EC",
    #);
    $object = SpellCheckFiniteStateCTcp->new(
    FstFile => "",
    EngineName => "$slang",
    EngineVersion => "v1.0-beta.3",
    Type => "port",
    PeerHost => '127.0.0.1',
    PeerPort => '8889',
    Proto => 'tcp',
    );
  }
  # user dictionary
  if (defined $user_wordlist and $user_wordlist ne "") {
    my @listUserEntries = ();
    my $entry = undef;
    @listUserEntries = split( ',', $user_wordlist );
    foreach $entry (@listUserEntries) {
      $entry =~ s/^\s+|\s+$//g; # trimming string
      $object->AddEntryUserDictionary($entry);
    }
  }
  foreach $word (@listWords) {
    $word =~ s/^\s+|\s+$//g; # trimming string
    $correct = $object->SpellCheck($word);
    if (not $correct) { # the word is misspelled
      #$object->AddIncorrectEntry($word);
      my $suggestions = $object->getSuggestions($word);
      if ($suggestions =~ /\?\?\?/)
      {
        $suggestions = "[\"???\"]";
      }
      else {
        $suggestions = "[$suggestions]";
      }
      my $ud = "false";
      $result = $result . "{ \"word\": \"$word\", \"ud\": \"$ud\", \"suggestions\": $suggestions}," ;
    }
  }
  # ########################### #
  #        Error corpus         #
  # ########################### #
  # Uncommenting one of the following lines will slow down the application considerably 
  #$object->AddDocumentToErrorCorpus($text);
  #$object->AddDocumentToErrorCorpuseXistdb($text, $slang);
  $result = substr($result , 0, length($result) - 1);
  # Printing the result 
  print $callback . "([$result])";
}

