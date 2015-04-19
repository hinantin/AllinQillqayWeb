#!/usr/bin/perl
package CIncorrectEntry;
use Moose;

has 'cpIncorrectEntryId' => (
  is  => 'ro',
  isa => 'Int',
  required => 1,
);

has 'cpEntry' => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

has 'cpIsCorrect' => (
  is  => 'rw',
  isa => 'Int',
  required => 1,
);

has 'cpDate' => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

has 'cpUser' => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

has 'cpFrecuency' => (
  is  => 'ro',
  isa => 'Int',
  required => 1,
);

has 'cpSLang' => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

no Moose;
1;
