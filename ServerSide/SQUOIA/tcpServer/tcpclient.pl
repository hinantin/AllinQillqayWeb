#!/usr/bin/perl

use strict;
use warnings;
use 5.010;
use IO::Socket::INET;
use Getopt::Long qw(GetOptions);

# "Acapela Heather22"
# "Acapela Klaus22 (German)"
# "Acapela Rosa22 (Spanish)"
# "IVONA 2 Eric OEM"
# "IVONA 2 Miguel OEM (Spanish)"


my $word_to_analyze;
my $port = '7891';
my $host = 'localhost';

GetOptions(
'word=s' => \$word_to_analyze,
'port=s' => \$port,
'host=s' => \$host,
) or die "Usage: $0 --word SINGLE-WORD --host IP --port NUMBER \n";

if ($word_to_analyze) {
    say $word_to_analyze;
    # auto-flush on socket
    $| = 1;
    
    # create a connecting socket
    my $socket = new IO::Socket::INET (PeerHost => $host, PeerPort => $port, Proto => 'tcp',);
    die "cannot connect to the server $!\n" unless $socket;
    print STDERR "connected to the server\n";
    
    # data to send to a server
    my $size = $socket->send($word_to_analyze);
    print STDERR "sent data of length $size\n";
    
    # notify server that request has been sent
    shutdown($socket, 1);
     
    # receive a response of up to 16384 characters from server
    my $response = "";
    $socket->recv($response, 16384);
    print "$response\n";
    
    $socket->close();
}
else {
    print "Usage: $0 --word SINGLE-WORD --host IP --port NUMBER \n";
}
