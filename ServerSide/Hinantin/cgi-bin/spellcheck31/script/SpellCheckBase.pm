package SpellCheckBase;
use Moose;

has 'FstFile' => ( is => 'rw', isa => 'Str', required => 1 );
has 'EngineName' => ( is => 'rw', isa => 'Str', required => 1 );
has 'EngineVersion' => ( is => 'rw', isa => 'Str', required => 1 );
has 'Type' => ( is => 'rw', isa => 'Str', required => 1 );

sub SpellCheck {
  my $self = shift;
  print "I don't know if it is correct or not\n";
  $self->maybe::next::method(@_);
}

sub getSuggestions {
  my $self = shift;
  print "We don't have any suggestions\n";
  $self->maybe::next::method(@_);
}

no Moose;

package SpellCheckFiniteStateCmd;
use Encode qw(encode_utf8);
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
  $stdout = substr($stdout , 0, length($stdout) - 2);
  return $stdout;
}

no Moose;

package SpellCheckFiniteStateCTcp;
use Moose;
use IO::Socket::INET;
extends 'SpellCheckBase';

has 'PeerHost' => ( is => 'rw', isa => 'Str', required => 1 );
has 'PeerPort' => ( is => 'rw', isa => 'Str', required => 1 );
has 'Proto' => ( is => 'rw', isa => 'Str', required => 1 );

sub main {
    my $self = shift;
    $self->mySub( 1 );
    $self->tbSub( 2 );
    $self->mySub( 3 );
}

sub SpellCheck {
  my $self = shift;
  my $words = undef;  
  ($words) = @_;
  # auto-flush on socket
  $| = 1;
  
  # create a connecting socket
  my $socket = new IO::Socket::INET (PeerHost => '127.0.0.1', PeerPort => '8888', Proto => 'tcp',);
  die "cannot connect to the server $!\n" unless $socket;
  print "connected to the server\n";
  
  # data to send to a server
  my $size = $socket->send($words);
  print "sent data of length $size\n";
  
  # notify server that request has been sent
  shutdown($socket, 1);
   
  # receive a response of up to 1024 characters from server
  my $response = "";
  $socket->recv($response, 1024);
  $socket->close();
  #print "$response\n";
  if ( "$response" =~ /\|correct:$/ ) { # the word is misspelled
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
  # auto-flush on socket
  $| = 1;
  
  # create a connecting socket
  my $socket = new IO::Socket::INET (PeerHost => '127.0.0.1', PeerPort => '8888', Proto => 'tcp',);
  die "cannot connect to the server $!\n" unless $socket;
  print "connected to the server\n";
  
  # data to send to a server
  my $size = $socket->send($words);
  print "sent data of length $size\n";
  
  # notify server that request has been sent
  shutdown($socket, 1);
   
  # receive a response of up to 1024 characters from server
  my $response = "";
  $socket->recv($response, 1024);
  $socket->close();
  my @listWords = ();
  @listWords = split( '|', $response );
  $response = $listWords[0];
  @listWords = split( ':', $response );
  $response = $listWords[1];
  @listWords = split( ',', $response );
  $response = "";
  my $word = "";
  foreach $word (@listWords) {
    $word =~ s/^\s+|\s+$//g; # trimming string
    $response = $response + "\"$word\", ";
  }
  $response = substr($response , 0, length($response) - 2);
  return $response;
}

no Moose;

package SpellCheckFiniteStateNSpell;
use Encode qw(encode_utf8);
use IO::CaptureOutput qw/capture/;
use Moose;
extends 'SpellCheckBase';

sub SpellCheck {
  my $self = shift;
  my $words = undef;  
  ($words) = @_; 
  my ($stdout, $stderr);
  capture sub {
    system("echo \"$words\" | hunspell -G -d $self->{SLang}");
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
  capture sub {
    system("echo \"$words\" | hunspell -d $self->{SLang}");
  } => \$stdout, \$stderr;
  my @listWords = ();
  @listWords = split( ':', $stdout );
  my $response = $listWords[1];
  $stdout =~ s/^\s+|\s+$//g; # trimming string
  @listWords = split( ',', $response );
  $response = "";
  my $word = "";
  foreach $word (@listWords) {
    $word =~ s/^\s+|\s+$//g; # trimming string
    $response = $response + "\"$word\", ";
  }
  $response = substr($response , 0, length($response) - 2);
  return $response;
}

no Moose;

1;
