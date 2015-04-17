#!/usr/bin/perl

use strict;
use warnings;
use 5.010;
use IO::Socket::INET;
use Getopt::Long qw(GetOptions);

my $word_to_analyze;
GetOptions('word=s' => \$word_to_analyze) or die "Usage: $0 --word SINGLE-WORD\n";
if ($word_to_analyze) {
    say $word_to_analyze;
# auto-flush on socket
$| = 1;

# create a connecting socket
my $socket = new IO::Socket::INET (
    PeerHost => '127.0.0.1',
    PeerPort => '8888',
    Proto => 'tcp',
);
die "cannot connect to the server $!\n" unless $socket;
print "connected to the server\n";
 
# data to send to a server
my $size = $socket->send($word_to_analyze);
print "sent data of length $size\n";
 
# notify server that request has been sent
shutdown($socket, 1);
 
# receive a response of up to 1024 characters from server
my $response = "";
$socket->recv($response, 1024);
print "$response\n";
 
$socket->close();
}
else {
print "Usage: $0 --word SINGLE-WORD\n";
}
