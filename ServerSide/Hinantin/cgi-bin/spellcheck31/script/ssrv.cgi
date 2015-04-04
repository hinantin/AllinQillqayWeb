#!/usr/bin/perl

use File::Temp qw/ tempdir /;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use lib '/usr/lib/cgi-bin/svc/spellcheck31/script';
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
  # print $callback . '({langList:{ltr: {"qu_QUZ3" : "Quechua Cusqueño", "qu_SRNCP" : "Quechua Sureño", "qu_EC" : "Kichwa Ecuatoriano", "qu_BO" : "Quechua Boliviano", "qu_SPA" : "Quechua Sureño (mejorado)", "cni" : "Asháninka"},rtl: {}},verLang : 6})';
  # print $callback . '({langList:{ltr: {"en_US" : "American English","fr_FR" : "French","de_DE" : "German","it_IT" : "Italian","es_ES" : "Spanish","en_GB" : "British English","en_GB" : "British English","la_VA" : "Latin","pt_BR" : "Brazilian Portuguese","da_DK" : "Danish","nl_NL" : "Dutch","nb_NO" : "Norwegian","pt_PT" : "Portuguese","sv_SE" : "Swedish","el_GR" : "Greek","en_CA" : "Canadian English","fr_CA" : "Canadian French","fi_FI" : "Finnish"},rtl: {}},verLang : 6})';
  # print $callback . 'scayt.opt({langList:{ltr: {"qu_QUZ3" : "Quechua cusqueño", "qu_SRNCP" : "Quechua sureño unificado<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;por Cerrón Palomino", "qu_EC" : "Kichwa ecuatoriano<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Hunspell)", "qu_BO" : "Quechua boliviano<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Myspell)", "qu_SPA" : "Quechua sureño unificado,<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;más raices españolas y<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;normalización automática", "cni" : "Asháninka"},rtl: {}},verLang : 6})';
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

