#!/usr/bin/perl
package FiniteStateFactory;

use Config::IniFiles;
use IO::Socket;
use strict;

sub new{
    my $class = shift;
    my %params = @_;
    my $self = {};
    $self->{CONFIGFILE} = $params{'CONFIGFILE'};
    $self->{SECTION} = $params{'SECTION'};
    my $CONFIG = Config::IniFiles->new( -file => $self->{CONFIGFILE});
    $self->{PROTOCOL} = $CONFIG->val( $self->{SECTION}, 'PROTOCOL');
    $self->{SOCKET} = $CONFIG->val( $self->{SECTION}, 'SOCKET');
    $self->{WORD} = undef;
    $self->{PORT} = $CONFIG->val( $self->{SECTION}, 'PORT');
    $self->{IPADDRESS} = $CONFIG->val( $self->{SECTION}, 'IPADDRESS');
    $self->{HISHOST} = $CONFIG->val( $self->{SECTION}, 'HISHOST');
    $self->{MAXLENGTH} = $CONFIG->val( $self->{SECTION}, 'MAXLENGTH');
    $self->{PORTNUMBER} = $CONFIG->val( $self->{SECTION}, 'PORTNUMBER');
    $self->{TIMEOUT} = $CONFIG->val( $self->{SECTION}, 'TIMEOUT');
    bless $self, $class;
    return $self;
}

sub CreateSocket {
    my $self = shift;
    return IO::Socket::INET->new(Proto  => $self->{PROTOCOL},
                              PeerPort  => $self->{PORTNUMBER},
                              PeerAddr  => $self->{IPADDRESS}) or die "Creating socket: $!\n";
}
1;
