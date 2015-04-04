#!/usr/bin/perl
package CUserDictionary;

sub new
{
    my $class = shift;
    my $self = {
        _cpUserDictionaryId => shift,
        _cpSLang => shift,
        _cpEntry => shift,
        _cpDate => shift,
        _cpUser => shift
    };
    bless $self, $class;
    return $self;
}

#cpUserDictionaryId
sub setcpUserDictionaryId {
    my ( $self, $cpUserDictionaryId ) = @_;
    $self->{_cpUserDictionaryId} = $cpUserDictionaryId if defined($cpUserDictionaryId);
    return $self->{_cpUserDictionaryId}; 
}
#cpSLang
sub setcpSLang {
    my ( $self, $cpSLang ) = @_;
    $self->{_cpSLang} = $cpSLang if defined($cpSLang);
    return $self->{_cpSLang}; 
}
#cpEntry
sub setcpEntry {
    my ( $self, $cpEntry ) = @_;
    $self->{_cpEntry} = $cpEntry if defined($cpEntry);
    return $self->{_cpEntry}; 
}
#cpRegistrationDate
sub setcpDate {
    my ( $self, $cpDate ) = @_;
    $self->{_cpDate} = $cpDate if defined($cpDate);
    return $self->{_cpDate}; 
}
#cpUser
sub setcpUser {
    my ( $self, $cpUser ) = @_;
    $self->{_cpUser} = $cpUser if defined($cpUser);
    return $self->{_cpUser}; 
}

sub getcpUserDictionaryId {
    my( $self ) = @_;
    return $self->{_cpUserDictionaryId};
}
sub getcpSLang {
    my( $self ) = @_;
    return $self->{_cpSLang};
}
sub getcpEntry {
    my( $self ) = @_;
    return $self->{_cpEntry};
}
sub getcpDate {
    my( $self ) = @_;
    return $self->{_cpDate};
}
sub getcpUser {
    my( $self ) = @_;
    return $self->{_cpUser};
}
1;
