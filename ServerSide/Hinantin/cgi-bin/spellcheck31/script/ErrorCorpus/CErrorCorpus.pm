#!/usr/bin/perl
package CErrorCorpus;

use BaseXClient;
use Time::HiRes;
use Config::IniFiles;
use warnings;
use strict;

sub new {
	my $self = {};
	my $CONFIG =
	  Config::IniFiles->new( -file =>
		  "/usr/lib/cgi-bin/spellcheck31/script/dbspellchecker/ConfigFile.ini"
	  );
	$self->{PLATFORM} = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'PLATFORM' );
	$self->{DATABASE} = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'DATABASE' );
	$self->{HOST}     = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'HOST' );
	$self->{PORT}     = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'PORT' );
	$self->{USER}     = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'USER' );
	$self->{PASSWORD} = $CONFIG->val( 'PRODUCTION_BASEX_HNTQhichwaErrorCorpus', 'PASSWORD' );
	bless($self);
	return $self;
}

Add {
  # create session
  my $session = Session->new($self->{PLATFORM}, $self->{PORT}, $self->{USER}, $self->{PASSWORD});

  # create query instance
  my $input = "for \$id in doc('/home/richard/Documents/BibleCorpus/bible-corpus-tools-master/XML_Bibles/Campa-NT.xml')//cesDoc//text//body//div//div//seg/\@id return concat(data(\$id),',')";
  my $query = $session->query($input);
  my $str = $query->execute();
  my @words = split(/,/, $str);
  # loop through all results
  #print scalar(@words);

  my $filename = 'report.txt';
  open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";

  foreach (@words) {
    my $id = "$_";
    $id =~ s/^\s+|\s+$//g;

    my $input2 = "for \$sentence in doc('/home/richard/Documents/BibleCorpus/bible-corpus-tools-master/XML_Bibles/Campa-NT.xml')//cesDoc//text//body//div//div//seg" .
"  where data(\$sentence/\@id) = '$id'" .
"  return " .
"    for \$sentence01 in doc ('/home/richard/Documents/BibleCorpus/bible-corpus-tools-master/XML_Bibles/English.xml')//cesDoc//text//body//div//div//seg[data(\@id) = '$id']" .
"    return concat(\$sentence//text(),'&#10;',\$sentence01//text())";
    my $query2 = $session2->query($input2);
    
    my $result = $query2->execute()."\n\n";
    print $fh "$result";
    print $result;
    $query2->close();

  }

  close $fh;
  print "done\n";

  $session2->close();
  # close query
  #$query2->close();
  $query->close();

  # close session

  $session->close();
}
1;
