#!/usr/bin/perl

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
  print $callback . '({langList:{ltr: {"cuz_simple_foma" : "Quechua Cusqueño", "uni_simple_foma" : "Quechua Sureño", "uni_extended_foma" : "Quechua Sureño Extendido", "bol_myspell" : "Quechua Boliviano", "ec_hunspell" : "Kichwa Ecuatoriano"},rtl: {}},verLang : 6})';
}
elsif ($cmd eq "getbanner") { 
  $callback = $query->param('callback');
  $customerid = $query->param('customerid');
  $run_mode = $query->param('run_mode');
  $format = $query->param('format');
  print $callback . '({ banner : false } )';
}
elsif ($cmd eq "user_dictionary") {
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
    EngineVersion => "v1.0-beta.1",
    Type => "port",
    PeerHost => '127.0.0.1',
    PeerPort => '8888',
    Proto => 'tcp',
    );
  }
  elsif ($slang eq "bol_myspell") {
    $object = SpellCheckFiniteStateNSpell->new(
    FstFile => "",
    EngineName => "$slang",
    EngineVersion => "v1.0-beta.1",
    Type => "cmd",
    Lang => "quh_BO",
    );
  }
  else { # ec_hunspell
    $object = SpellCheckFiniteStateNSpell->new(
    FstFile => "",
    EngineName => "$slang",
    EngineVersion => "v1.0-beta.1",
    Type => "cmd",
    Lang => "qu_EC",
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
      $object->AddIncorrectEntry($word);
      my $suggestions = $object->getSuggestions($word);
      $suggestions = "[$suggestions]";
      my $ud = "false";
      $result = $result . "{ \"word\": \"$word\", \"ud\": \"$ud\", \"suggestions\": $suggestions}," ;
    }
  }
  # ########################### #
  #        Error corpus         #
  # ########################### #
  # Uncommenting the following line will slow down the application considerably 
  # $object->AddDocumentToErrorCorpus($text);
  $result = substr($result , 0, length($result) - 1);
  print $callback . "([$result])";
}

