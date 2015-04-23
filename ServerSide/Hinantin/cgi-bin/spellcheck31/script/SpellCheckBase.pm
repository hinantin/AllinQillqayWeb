package SpellCheckBase;
use XML::Writer;
use IO::File;
use lib '/usr/lib/cgi-bin/spellcheck31/script/ErrorCorpus';
use BaseXClient;
use CXmlDocument;
use lib '/usr/lib/cgi-bin/spellcheck31/script/UserDictionary';
use CUserDictionary;
use UserDictionaryDao;
use IncorrectEntryDao;
use Encode qw(encode_utf8);
use Moose;

has 'FstFile' => ( is => 'rw', isa => 'Str', required => 1 );
has 'EngineName' => ( is => 'rw', isa => 'Str', required => 1 );
has 'EngineVersion' => ( is => 'rw', isa => 'Str', required => 1 );
has 'Type' => ( is => 'rw', isa => 'Str', required => 1 );

# ################################### #
#          Incorrect Entry            #
# ################################### #
sub AddIncorrectEntry {
  my $self = shift;
  my ($entry) = @_;
  my $incorrectentry = new IncorrectEntryDao();
  my $slang = $self->EngineName();
  my $object = CIncorrectEntry->new(
    cpIncorrectEntryId => 0,
    cpEntry => "$entry",
    cpIsCorrect => 0,
    cpDate => "",
    cpUser => "rcastro",
    cpFrecuency => 0,
    cpSLang => "$slang",
  );
  $incorrectentry->Save($object);
}

# ################################### #
#          User Dictionary            #
# ################################### #
sub AddEntryUserDictionary {
  my $self = shift;
  my ($entry) = @_;
  my $userdict = new UserDictionaryDao();
  my $slang = $self->EngineName();
  my $object = CUserDictionary->new(
    cpUserDictionaryId => 0,
    cpSLang => "$slang",
    cpEntry => "$entry",
    cpDate => "",
    cpUser => "rcastro",
  );
  $userdict->Save($object);
}

sub DeleteEntryUserDictionary {
  my $self = shift;
  my ($entry) = @_;
  my $userdict = new UserDictionaryDao();
  my $slang = $self->EngineName();
  my $object = CUserDictionary->new(
    cpUserDictionaryId => 0,
    cpSLang => "$slang",
    cpEntry => "$entry",
    cpDate => "",
    cpUser => "rcastro",
  );
  $userdict->Delete($object);
}

sub DoesUserDictionaryContainEntry {
  my $self = shift;
  my ($entry) = @_;
  my $userdict = new UserDictionaryDao();
  my $slang = $self->EngineName();
  my $object = CUserDictionary->new(
    cpUserDictionaryId => 0,
    cpSLang => "$slang",
    cpEntry => "$entry",
    cpDate => "",
    cpUser => "rcastro",
  );
  return $userdict->DoesUserDictionaryContainEntry($object);
}

# ################################### #
#          Error Corpus               #
# ################################### #

sub AddDocumentToErrorCorpus {
  my $self = shift;
  my ($text) = @_;
  my $xmldoc = new CXmlDocument($self);
  my ($filename, $xmlcontent) = $xmldoc->CreateXmlFile($text);
  $xmldoc->Add($filename, $xmlcontent);
}

# ################################### #
#          Spell Checking             #
# ################################### #

sub SpellCheck {
  my $self = shift;
  # I don't know if it is correct or not
  $self->maybe::next::method(@_);
}

sub getSuggestions {
  my $self = shift;
  # We don't have any suggestions
  $self->maybe::next::method(@_);
}

no Moose;

package SpellCheckFiniteStateCmd;
use IO::CaptureOutput qw/capture/;
use Moose;
extends 'SpellCheckBase';

sub SpellCheck {
  my $self = shift;
  my $words = undef;  
  ($words) = @_;
  my ($stdout, $stderr);
  my $fstfile = $self->FstFile();
  capture sub {
    system("echo \"$words\" | flookup -bx $fstfile");
  } => \$stdout, \$stderr;
  $stdout =~ s/^\s+|\s+$//g; # trimming string
  if ( "$stdout" =~ /\+\?/ ) { # the word is misspelled
    return 0;
  }
  else {
    return 1;
  }
}

sub getSuggestions {
  my $self = shift;
  my $words = undef;
  my $number = "15"; #number of suggestions 
  ($words) = @_; 
  my ($stdout, $stderr);
  my $fstfile = $self->FstFile();
  capture sub {
    system("echo \"$words\" | suggestions -l $number $fstfile");
  } => \$stdout, \$stderr;
  $stdout =~ s/,$//g; # trimming string
  return $stdout;
}

no Moose;

package SpellCheckFiniteStateCTcp;
use IO::Socket::INET;
use Moose;
extends 'SpellCheckBase';

has 'PeerHost' => ( is => 'rw', isa => 'Str', required => 1 );
has 'PeerPort' => ( is => 'rw', isa => 'Str', required => 1 );
has 'Proto' => ( is => 'rw', isa => 'Str', required => 1 );

sub Consult {
  my $self = shift;
  my $words = undef;  
  ($words) = @_;
  # auto-flush on socket
  $| = 1;
  
  # create a connecting socket
  my $socket = new IO::Socket::INET (PeerHost => $self->PeerHost(), PeerPort => $self->PeerPort(), Proto => $self->Proto(),);
  die "cannot connect to the server $!\n" unless $socket;
  # connected to the server
  
  # data to send to a server
  my $size = $socket->send($words);
  # sent data of length $size
  
  # notify server that request has been sent
  shutdown($socket, 1);
  
  # receive a response of up to 1024 characters from server
  my $response = "";
  $socket->recv($response, 1024);
  $socket->close();
  
  return $response;
}

sub SpellCheck {
  my $self = shift;
  my $words = undef;
  ($words) = @_;
  my $response = $self->Consult($words);
  if ( "$response" =~ /^incorrect:\|/ ) { # the word is misspelled
    return 1;
  }
  else {
    return 0;
  }
}

sub getSuggestions {
  my $self = shift;
  my $words = undef;  
  ($words) = @_;
  my $response = $self->Consult($words);
  my @listWords = ();
  @listWords = split( '\|', $response );
  $response = $listWords[0];
  @listWords = split( ':', $response );
  $response = $listWords[1];
  @listWords = split( ',', $response );
  $response = "";
  my $word = "";
  foreach $word (@listWords) {
    $word =~ s/^\s+|\s+$//g; # trimming string
    $response = "$response\"$word\", ";
  }
  $response =~ s/,\s$//g; # trimming string
  return $response;
}

no Moose;

package SpellCheckFiniteStateNSpell;
use IO::CaptureOutput qw/capture/;
use Moose;
extends 'SpellCheckBase';

has 'Lang' => ( is => 'rw', isa => 'Str', required => 1 );

sub SpellCheck {
  my $self = shift;
  my $words = undef;  
  ($words) = @_; 
  my ($stdout, $stderr);
  my $lang = $self->Lang();
  capture sub {
    system("echo \"$words\" | hunspell -G -d $lang");
  } => \$stdout, \$stderr;
  if ( "$stdout" eq "" ) { # the word is misspelled
    return 0;
  }
  else {
    return 1;
  }
}

sub getSuggestions {
  my $self = shift;
  my $words = undef;  
  ($words) = @_; 
  my ($stdout, $stderr);
  my $lang = $self->Lang();
  capture sub {
    system("echo \"$words\" | hunspell -d $lang");
  } => \$stdout, \$stderr;
  my @listWords = ();
  @listWords = split( ':', $stdout );
  my $response = $listWords[1];
  @listWords = split( '\n', $response );
  $response = $listWords[0];
  $stdout =~ s/^\s+|\s+$//g; # trimming string
  @listWords = split( ',', $response );
  $response = "";
  my $word = "";
  foreach $word (@listWords) {
    $word =~ s/^\s+|\s+$//g; # trimming string
    $response = "$response\"$word\", ";
  }
  $response =~ s/,\s$//g; # trimming string
  return $response;
}

no Moose;

1;
