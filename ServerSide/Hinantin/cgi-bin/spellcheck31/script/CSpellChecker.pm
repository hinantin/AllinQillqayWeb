#!/usr/bin/perl
package CSpellChecker;

use strict;
use warnings;
use Encode qw(encode_utf8);
use IO::CaptureOutput qw/capture/;
use lib '/usr/lib/cgi-bin/spellcheck31/script/UserDictionary';
use IncorrectEntryDao;
use CIncorrectEntry;
use CorrectEntryDao;
use CCorrectEntry;
use DateTime;

sub new {
   my $class = shift;
   my($FstFile,$SLang,$Type) = @_;
   my $self = {"FstFile"=>$FstFile,"SLang"=>$SLang,"Type"=>$Type,};
   #print "File: " . $FstFile . "\n";
   bless($self, $class);
   return $self;
}

sub ListWrongSpellings {
  my $file = undef;
  my $self = shift;
  my $w = undef;
  my $unk = undef;
  ($file) = @_;
  my $words = "";
  my $filelike = qq{$file};
  open my $fh, '<', \$filelike or die $!;  
  while (<$fh>) {
    if (/\+\?/) {
      if (/\t/) {
	      ($w,$unk) = split /\t/;
	      if ($w =~ /[A-Za-zÑÁÉÍÓÚÜñáéíóúü']/) {
	        $words = $words . "$w\n";  
	      }      	
      }	
    else {}
    }
  }
  return $words;
}

sub ListRightSpellings {
  my $file = undef;
  my $self = shift;
  my $w = undef;
  my $unk = undef;
  ($file) = @_;
  my $words = "";
  my $filelike = qq{$file};
  open my $fh, '<', \$filelike or die $!;  
  while (<$fh>) {
    if (/\+\?/) {}
    elsif(/^\s*$/) { #empty line
      next;
    } else {
      #print;
      ($w,$unk) = split /\t/;
      $words = $words . "$w\n";  
    }
  }
  return $words;
}

sub AnalyzeCuzco {
  my $self = shift;
  my $words = undef;
  ($words) = @_;
  my ($stdout, $stderr);
  capture sub {
    system("echo \"$words\" | flookup $self->{FstFile}");
  } => \$stdout, \$stderr;
  return $stdout;
}

# AllinQillqayWeb
sub SpellCheck {
  my $self = shift;
  my $words = undef;  
  ($words) = @_;
  my ($stdout, $stderr);
  capture sub {
    system("echo \"$words\" | flookup -bx $self->{FstFile}");
  } => \$stdout, \$stderr;
  $stdout =~ s/^\s+|\s+$//g; # trimming string
  if ( "$stdout" =~ /\+\?/ ) { # the word is misspelled
    return 0;
  }
  else {
    return 1;
  }
}

sub FMed {
  my $self = shift;
  my $words = undef;
  my $number = "15"; #number of suggestions 
  ($words) = @_; 
  my ($stdout, $stderr);
  capture sub {
    system("echo \"$words\" | ./fmed -l $number $self->{FstFile}");
  } => \$stdout, \$stderr;
  return $stdout;
}

# AllinQillqayWeb
sub Suggestions {
  my $self = shift;
  my $words = undef;
  my $number = "15"; #number of suggestions 
  ($words) = @_; 
  my ($stdout, $stderr);
  capture sub {
    system("echo \"$words\" | suggestions -l $number $self->{FstFile}");
  } => \$stdout, \$stderr;
  return $stdout;
}

sub spellcheckjson {
  my $self = shift;
  my $words = undef;
  my $number = "15"; #number of suggestions 
  ($words) = @_; 
  my ($stdout, $stderr);
  capture sub {
    system("echo \"$words\" | ./spellcheck_json -l $number $self->{FstFile}");
  } => \$stdout, \$stderr;
  return $stdout;
}

sub spellcheckjson_cni {
  my $self = shift;
  my $words = undef;
  my $number = "15"; #number of suggestions 
  ($words) = @_; 
  my ($stdout, $stderr);
  capture sub {
    system("python ./$self->{FstFile} -i \"$words\" ");
  } => \$stdout, \$stderr;
  return $stdout;
}

sub Hunspell {
  my $self = shift;
  my $words = undef;  
  ($words) = @_; 
  my ($stdout, $stderr);
  capture sub {
    system("echo \"$words\" | hunspell -d $self->{SLang}");
  } => \$stdout, \$stderr;
  return $stdout;
}

sub ListRightSpellingsHunspell {
  my $file = undef;
  my $self = shift;
  my $w = undef;
  my $unk = undef;
  ($file) = @_;
  my $words = "";
  my $filelike = qq{$file};
  open my $fh, '<', \$filelike or die $!;  
  while (<$fh>) {
	chomp;
	  my ($stdout, $stderr);
	  capture sub {
		system("echo $_ | hunspell -G -d $self->{SLang}");
	  } => \$stdout, \$stderr;
    if (/\+\?/ eq $stdout) {}
    elsif(/^\s*$/ eq $stdout) { #empty line
      next;
    } else {
      $words = $words . "$stdout";  
    }
  }
  return $words;
}

sub ListWrongSpellingsHunspell {
  my $file = undef;
  my $self = shift;
  my $w = undef;
  my $unk = undef;
  ($file) = @_;
  my $words = "";
  my $filelike = qq{$file};
  open my $fh, '<', \$filelike or die $!;  
  while (<$fh>) {
	chomp;
	  my ($stdout, $stderr);
	  capture sub {
		system("echo $_ | hunspell -L -d $self->{SLang}");
	  } => \$stdout, \$stderr;
    if (/\+\?/ eq $stdout) {}
    elsif(/^\s*$/ eq $stdout) { #empty line
      next;
    } else {
      $words = $words . "$stdout";  
    }
  }
  return $words;
}

sub Tokenize {
  my $file = undef;
  my $self = shift;
  my @words;
  ($file) = @_;
  my $wordsList = "";
  my $filelike = qq{$file};
  open my $fh, '<', \$filelike or die $!;  
  while (<$fh>) {
    @words = split(/([\s+|,|\.|:|;|\-|\[|\]|\(|\)|\?|\"|\¡|\–|\¿|\!|\/|%|…])/);
    foreach (@words) {
      if (m/^\s*$/) { next;}
      else {$wordsList = $wordsList . $_."\n";}
    }
  }
  return $wordsList;
}

sub FormatSpellCheckOutput {
  my $file = undef;
  my $self = shift;
  ($file) = @_; 
  open FILE, "< $file" or die "Can't open $file : $!";

  my $i = 0;
  my $new = 1;
  my $corr = undef;
  my $word = undef;
  my @words = ();
  my %spellings;

while (<FILE>) {
  if (/Cost\[f\]:/ or /^Calculating heuristic/ or /^Using confusion matrix/) {
    # do nothing
  }
  elsif (/^$/) {
    $new = 1;
  }
  else {
    chomp;
    # s/\*//g;
    if ($new) {
      $corr = $_;
      $new = 0;
    }
    else {
      $word = $_;
      if ($i==0 or ($words[$i-1] ne $word)) {
      $words[$i] = $word;
      $i++;
    }
    $spellings{$word}{$corr}=1;	
   }
  }
}

foreach $word (@words) {
  print "$word:\n";
  foreach $corr (keys %{$spellings{$word}}) {
    print "\t$corr\n";
  }
}
}

sub FormatSpellCheckOutput_Json_Hunspell {
  my $file = undef;
  my $incorrectWord = undef;
  my $slang = undef;
  my $customerid = undef;
  my $self = shift;
  ($incorrectWord,$slang,$customerid,$file) = @_; 

  my $i = 0;
  my $new = 1;
  my $corr = undef;
  my $word = undef;
  my @words = ();
  my %spellings;
  my $incorrect = undef;
  
my $filelike = qq{$file};
open my $fh, '<', \$filelike or die $!;
my @correctWords = ();
while (<$fh>) {
  if (/^Hunspell 1.3.2/) {
    next;
  }
  elsif (/^$/) {
    next;
  }
  else {
    chomp;
	my @values =  split(/[:,]/, $_);
	shift @values;
	  foreach my $element (@values) {
		$element =~ s/^\s+//;
		$element =~ s/\s+$//;
		push(@correctWords, $element); 
	  }
  }
} close $fh or die $!;
  $incorrect = "";
  $incorrect = "[\"" . $incorrectWord . "\",[";
  foreach $corr (@correctWords) {
    #print "\n$corr\n";
    $incorrect = $incorrect . "\"" . $corr . "\",";
  }
  $incorrect = substr $incorrect, 0, length($incorrect) - 1;
  $incorrect = "$incorrect]]";

my $oIncorrectEntry = new CIncorrectEntry();
$oIncorrectEntry->setcpIncorrectEntryId(0);
$oIncorrectEntry->setcpEntry($incorrectWord);
$oIncorrectEntry->setcpIsCorrect("INCORRECT");
$oIncorrectEntry->setcpDate(DateTime->now);
$oIncorrectEntry->setcpUser($customerid);
$oIncorrectEntry->setcpFrecuency(0);
$oIncorrectEntry->setcpSLang($slang);
my $oIncorrectEntryDao = new IncorrectEntryDao();
my $Object = $oIncorrectEntryDao->Save($oIncorrectEntry);
return $incorrect;
}

sub FormatSpellCheckOutput_Json {
  my $file = undef;
  my $incorrectWord = undef;
  my $slang = undef;
  my $customerid = undef;
  my $self = shift;
  ($incorrectWord,$slang,$customerid,$file) = @_; 

  my $i = 0;
  my $new = 1;
  my $corr = undef;
  my $word = undef;
  my @words = ();
  my %spellings;
  my $incorrect = "==============================================";
  
my $filelike = qq{$file};
open my $fh, '<', \$filelike or die $!;
my @correctWords = ();
while (<$fh>) {
  if (/Cost\[f\]:/ or /^Calculating heuristic/ or /^Using confusion matrix/) {
    next;
  }
  elsif (/^$/) {
    next;
  }
  else {
    chomp;
	my $element = $_;
	if ((grep {$_ ne $element} @correctWords) || (scalar(@correctWords) == 0)) {
	  if ($element ne $incorrectWord) {
		push(@correctWords, $element);
	  }
	}
  }
} close $fh or die $!;
  $incorrect = "";
  $incorrect = "[\"" . $incorrectWord . "\",[";
  foreach $corr (@correctWords) {
    #print "\n$corr\n";
    $incorrect = $incorrect . "\"" . $corr . "\",";
  }
  $incorrect = substr $incorrect, 0, length($incorrect) - 1;
  $incorrect = "$incorrect]]";

my $oIncorrectEntry = new CIncorrectEntry();
$oIncorrectEntry->setcpIncorrectEntryId(0);
$oIncorrectEntry->setcpEntry($incorrectWord);
$oIncorrectEntry->setcpIsCorrect("INCORRECT");
$oIncorrectEntry->setcpDate(DateTime->now);
$oIncorrectEntry->setcpUser($customerid);
$oIncorrectEntry->setcpFrecuency(0);
$oIncorrectEntry->setcpSLang($slang);
my $oIncorrectEntryDao = new IncorrectEntryDao();
my $Object = $oIncorrectEntryDao->Save($oIncorrectEntry);
return $incorrect;
}

sub SaveCorrectEntry {
  my $cpIncomingWord = undef;
  my $cpSLang = undef;
  my $self = shift;
  ($cpIncomingWord,$cpSLang) = @_; 
  my $oCorrectEntry = new CCorrectEntry();
  $oCorrectEntry->setcpCorrectEntryId(undef);
  $oCorrectEntry->setcpCorrectEntry(undef);
  $oCorrectEntry->setcpIncorrectEntryId(undef);
  $oCorrectEntry->setcpIncomingWord($cpIncomingWord);
  $oCorrectEntry->setcpFrecuency(undef);
  $oCorrectEntry->setcpUser(undef);
  $oCorrectEntry->setcpSLang($cpSLang);
  $oCorrectEntry->setcpRegistrationDate(undef);
  my $oCorrectEntryDao = new CorrectEntryDao();
  my $Object = $oCorrectEntryDao->Save($oCorrectEntry); 
  return $Object;    
}
1;

