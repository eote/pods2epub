#!/usr/bin/perl -w
use strict;
use warnings;

use lib "lib";
use Perldoc::XHTML;


my $source=`perldoc -l $ARGV[0]`;
chomp($source);
print parse_file($source),"\n";
