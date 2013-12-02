#!/usr/bin/perl -w
use strict;
use warnings;
use lib qw(lib ../lib);
use Perldoc::XHTML;

my @text;
while(<>) {
	push @text,$_;
}
print parse_string(join("",@text));
