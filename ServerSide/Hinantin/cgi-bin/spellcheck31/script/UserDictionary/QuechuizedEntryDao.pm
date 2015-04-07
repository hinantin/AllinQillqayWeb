package QuechuizedEntryDao;

use FiniteStateFactory;
use strict;
our @ISA = qw(FiniteStateFactory);    # inherits from FiniteStateFactory

sub new {
    my $class = shift;
    # Call the constructor of the parent class, Person.
    my $self = $class->SUPER::new( 'CONFIGFILE' => "ConfigFile.ini", 'SECTION' =>"PRODUCTION_QUECHUIZE" );    
    bless $self, $class;
    return $self;
}

sub Eval {
    my $self = shift;
    ($self->{WORD}) = @_;    
    $self->{SOCKET} = $self->CreateSocket();
    $self->{SOCKET}->send($self->{WORD}) or die "send: $!";

    eval {
       local $SIG{ALRM} = sub { die "time out" };
       alarm $self->{TIMEOUT};
       $self->{SOCKET}->recv($self->{WORD}, $self->{MAXLENGTH}) or die "recv: $!";
       alarm 0;
    } or die "localhost timed out after $self->{TIMEOUT} seconds.\n";
    my @LINE = split(/\t/,$self->{WORD});
    return $LINE[1];
    #return $self->{WORD};
}
