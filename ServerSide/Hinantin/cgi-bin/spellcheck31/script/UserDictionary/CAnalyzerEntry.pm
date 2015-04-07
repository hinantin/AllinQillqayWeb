#!/usr/bin/perl
package CAnalyzerEntry;

sub new
{
    my $class = shift;
    my $self = {
        _OID => shift,
        _Descripcion => shift,
        _Tipo => shift
    };
    bless $self, $class;
    return $self;
}

sub setOID {
    my ( $self, $OID ) = @_;
    $self->{_OID} = $OID if defined($OID);
    return $self->{_OID}; 
}

sub getOID {
    my( $self ) = @_;
    return $self->{_OID};
}

sub setDescripcion {
    my ( $self, $Descripcion ) = @_;
    $self->{_Descripcion} = $Descripcion if defined($Descripcion);
    return $self->{_Descripcion};
}

sub getDescripcion {
    my( $self ) = @_;
    return $self->{_Descripcion};
}

sub setTipo {
    my ( $self, $Tipo ) = @_;
    $self->{_Tipo} = $Tipo if defined($Tipo);
    return $self->{_Tipo};
}

sub getTipo {
    my( $self ) = @_;
    return $self->{_Tipo};
}
1;
