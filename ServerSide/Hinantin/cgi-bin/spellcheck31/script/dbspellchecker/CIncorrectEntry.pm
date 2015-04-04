#!/usr/bin/perl
package CIncorrectEntry;

sub new
{
    my $class = shift;
    my $self = {
        _cpIncorrectEntryId => shift,
        _cpEntry => shift,
        _cpIsCorrect => shift,
        _cpDate => shift,
        _cpUser => shift,
        _cpFrecuency => shift,
        _cpSLang => shift
    };
    bless $self, $class;
    return $self;
}

# cpIncorrectEntryId
sub setcpIncorrectEntryId {
    my ( $self, $cpIncorrectEntryId ) = @_;
    $self->{_cpIncorrectEntryId} = $cpIncorrectEntryId if defined($cpIncorrectEntryId);
    return $self->{_cpIncorrectEntryId}; 
}

sub getcpIncorrectEntryId {
    my( $self ) = @_;
    return $self->{_cpIncorrectEntryId};
}

# cpEntry
sub setcpEntry {
    my ( $self, $cpEntry ) = @_;
    $self->{_cpEntry} = $cpEntry if defined($cpEntry);
    return $self->{_cpEntry}; 
}

sub getcpEntry {
    my( $self ) = @_;
    return $self->{_cpEntry};
}

# cpIsCorrect
sub setcpIsCorrect {
    my ( $self, $cpIsCorrect ) = @_;
    $self->{_cpIsCorrect} = $cpIsCorrect if defined($cpIsCorrect);
    return $self->{_cpIsCorrect}; 
}

sub getcpIsCorrect {
    my( $self ) = @_;
    return $self->{_cpIsCorrect};
}

# cpDate
sub setcpDate {
    my ( $self, $cpDate ) = @_;
    $self->{_cpDate} = $cpDate if defined($cpDate);
    return $self->{_cpDate}; 
}

sub getcpDate {
    my( $self ) = @_;
    return $self->{_cpDate};
}

# cpUser
sub setcpUser {
    my ( $self, $cpUser ) = @_;
    $self->{_cpUser} = $cpUser if defined($cpUser);
    return $self->{_cpUser}; 
}

sub getcpUser {
    my( $self ) = @_;
    return $self->{_cpUser};
}

#cpFrecuency
sub setcpFrecuency {
    my ( $self, $cpFrecuency ) = @_;
    $self->{_cpFrecuency} = $cpFrecuency if defined($cpFrecuency);
    return $self->{_cpFrecuency}; 
}

sub getcpFrecuency {
    my( $self ) = @_;
    return $self->{_cpFrecuency};
}

#cpSLang
sub setcpSLang {
    my ( $self, $cpSLang ) = @_;
    $self->{_cpSLang} = $cpSLang if defined($cpSLang);
    return $self->{_cpSLang}; 
}

sub getcpSLang {
    my( $self ) = @_;
    return $self->{_cpSLang};
}
1;
