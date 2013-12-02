#!/usr/bin/perl -w
# $Id$
use strict;
use warnings;
use constant DEBUG=>0;
if(DEBUG) {
	require Data::Dumper;
}

use lib ("lib","../lib");
use Perldoc qw/perldoc_search perldoc_files/;
use Perldoc::XHTML;
use Perldoc::Names;

my @OPTIONS = qw/
	search|s=s
	list|l=s
	help|h
	include|i=s
	exclude|x=s
/;
my %OPTS;
if(@ARGV)
{
    require Getopt::Long;
    Getopt::Long::GetOptions(\%OPTS,@OPTIONS);
}
else {
	$OPTS{'help'} = 1;
}
if($OPTS{'help'} or $OPTS{'manual'}) {
	require Pod::Usage;
	my $v = $OPTS{'help'} ? 1 : 2;
	Pod::Usage::pod2usage(-exitval=>$v,-verbose=>$v);
    exit $v;
}

my @paths = split(/\s*;\s*/,$OPTS{search}) if($OPTS{search});
print STDERR "Searching path: @paths\n";
my $listname = $OPTS{'list'};
my @files;

if($listname) {
	my $names = $PERLDOC_NAMES->{$listname};
	die("Error: no list name $listname.\n") unless($names && ref $names);
	foreach(@$names) {
		my $file = perldoc_search($_,@paths);
		if($file) {
			push @files,[$_,$file];
		}
		else {
			print STDERR "Warnning: document for $_ not found.\n";
		}
	}
}
elsif(@paths) {
	@files = perldoc_files(@paths);
}
else {
	die("Error: Nothing to do.\n");
}

print "@ARGV\n";

my $OUTPUTDIR = shift(@ARGV) || "./";

mkdir $OUTPUTDIR unless(-d $OUTPUTDIR);


if(DEBUG) {
	print STDERR Data::Dumper->Dump([\@files],['@files']);
	exit;
}

foreach my $file (@files) {
	my $name = $file->[0];
	my $input_filename = $file->[1];
	my $output_filename = $name;
	$output_filename =~ s/:+|\/+|\\+/_/g;
	$output_filename .= ".html";
	print STDERR "\r=> $output_filename ...               ";
	$output_filename  = File::Spec->catfile($OUTPUTDIR,$output_filename);
	#if(!DEBUG) {
		my $html = parse_file($input_filename);
		#if(index($html,'<h1 id="NAME">NAME</h1>')>0) {
		if(index($html,'<h1')>0) {
			open FO,">:utf8",$output_filename or die("\nError: open file failed for $output_filename: $!\n");
			print FO $html;
			close FO;
		}
		else {
			print STDERR "\b\b\b\b\b\b\b\b [Error: text less xhtml]\n";
		}
#	}
#	print STDERR "\n";
}
print STDERR "\n";

