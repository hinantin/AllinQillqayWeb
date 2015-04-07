#!/usr/bin/perl
package CCorrectEntry;

sub new
{
    my $class = shift;
    my $self = {
        _cpCorrectEntryId => shift,
        _cpCorrectEntry => shift,
        _cpIncorrectEntryId => shift,
        _cpIncomingWord => shift,
        _cpFrecuency => shift,
        _cpSLang => shift,
        _cpDate => shift,
        _cpUser => shift
    };
    bless $self, $class;
    return $self;
}

#cpCorrectEntryId
sub setcpCorrectEntryId {
    my ( $self, $cpCorrectEntryId ) = @_;
    $self->{_cpCorrectEntryId} = $cpCorrectEntryId if defined($cpCorrectEntryId);
    return $self->{_cpCorrectEntryId}; 
}
#cpCorrectEntry
sub setcpCorrectEntry {
    my ( $self, $cpCorrectEntry ) = @_;
    $self->{_cpCorrectEntry} = $cpCorrectEntry if defined($cpCorrectEntry);
    return $self->{_cpCorrectEntry}; 
}
#cpIncorrectEntryId
sub setcpIncorrectEntryId {
    my ( $self, $cpIncorrectEntryId ) = @_;
    $self->{_cpIncorrectEntryId} = $cpIncorrectEntryId if defined($cpIncorrectEntryId);
    return $self->{_cpIncorrectEntryId}; 
}
#cpIncomingWord
sub setcpIncomingWord {
    my ( $self, $cpIncomingWord ) = @_;
    $self->{_cpIncomingWord} = $cpIncomingWord if defined($cpIncomingWord);
    return $self->{_cpIncomingWord}; 
}
#cpFrecuency
sub setcpFrecuency {
    my ( $self, $cpFrecuency ) = @_;
    $self->{_cpFrecuency} = $cpFrecuency if defined($cpFrecuency);
    return $self->{_cpFrecuency}; 
}
#cpUser
sub setcpUser {
    my ( $self, $cpUser ) = @_;
    $self->{_cpUser} = $cpUser if defined($cpUser);
    return $self->{_cpUser}; 
}
#cpSLang
sub setcpSLang {
    my ( $self, $cpSLang ) = @_;
    $self->{_cpSLang} = $cpSLang if defined($cpSLang);
    return $self->{_cpSLang}; 
}
#cpRegistrationDate
sub setcpDate {
    my ( $self, $cpDate ) = @_;
    $self->{_cpDate} = $cpDate if defined($cpDate);
    return $self->{_cpDate}; 
}

sub getcpCorrectEntryId {
    my( $self ) = @_;
    return $self->{_cpCorrectEntryId};
}
sub getcpCorrectEntry {
    my( $self ) = @_;
    return $self->{_cpCorrectEntry};
}
sub getcpIncorrectEntryId {
    my( $self ) = @_;
    return $self->{_cpIncorrectEntryId};
}
sub getcpIncomingWord {
    my( $self ) = @_;
    return $self->{_cpIncomingWord};
}
sub getcpFrecuency {
    my( $self ) = @_;
    return $self->{_cpFrecuency};
}
sub getcpUser {
    my( $self ) = @_;
    return $self->{_cpUser};
}
sub getcpSLang {
    my( $self ) = @_;
    return $self->{_cpSLang};
}
sub getcpDate {
    my( $self ) = @_;
    return $self->{_cpDate};
}
1;


