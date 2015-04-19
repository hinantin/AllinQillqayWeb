#!/usr/bin/perl
package CUserDictionary;
use Moose;

has 'cpUserDictionaryId' => (
  is  => 'ro',
  isa => 'Int',
  required => 1,
);

has 'cpSLang' => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

has 'cpEntry' => (
  is  => 'ro',
  isa => 'Str',
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

no Moose;
1;
