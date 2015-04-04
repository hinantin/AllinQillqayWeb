#!/usr/bin/perl

use File::Temp qw/ tempdir /;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use lib '/usr/lib/cgi-bin/spellcheck31/script';
use CSpellChecker;
my $query = new CGI();
print $query -> header(
-type => 'text/javascript; charset=UTF-8',
);
use Encode;

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
  print $callback . '({langList:{ltr: {"qu_QUZ3" : "Quechua Cusqueño", "qu_SRNCP" : "Quechua Sureño"},rtl: {}},verLang : 6})';
}
elsif ($cmd eq "getbanner") { 
  $callback = $query->param('callback');
  $customerid = $query->param('customerid');
  $run_mode = $query->param('run_mode');
  $format = $query->param('format');
  print $callback . '({ banner : false } )';
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

  # ########################
  # Local variables 
  # ########################
  my @listWords = ();
  my $object = undef;
  my $spellcheck = "";
  my $result = "";
  
  @listWords = split( ',', $text );
  if ($slang eq "qu_SRNCP") {
    $object = CSpellChecker->new( "spellcheckUnificado.fst", $slang );
  }
  else { # By default we use Cuzco Quechua
    $object = CSpellChecker->new( "spellcheck.fst", $slang );
  }
  foreach $word (@listWords) {
    $word =~ s/^\s+|\s+$//g;
    $spellcheck = $object->SpellCheck($word);
    $spellcheck =~ s/^\s+|\s+$//g;
    if ( "$spellcheck" =~ /\+\?/ ) { # Error 
      my $suggestions = $object->Suggestions($word);
      $suggestions = substr($suggestions , 0, length($suggestions) - 2);
      #print $object->FormatSpellCheckOutput($sug);
      $suggestions = "[$suggestions]";
      my $ud = "false";
      $result = $result . "{ \"word\": \"$word\", \"ud\": \"$ud\", \"suggestions\": $suggestions}," ;
    }
  }

  #$custom_dictionary = $query->param('custom_dictionary');
  #$user_dictionary = $query->param('user_dictionary');
  #$user_wordlist = $query->param('user_wordlist'); 
  $result = substr($result , 0, length($result) - 1);
  print $callback . "([$result])";
}

