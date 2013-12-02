#!/usr/bin/perl -w
# $Id$
=head1 NAME

make_epub - create an EPUB ebook from a directory

=head1 SYNOPSIS

 make-epub [options] path/to/epubdir book_title

Collect html files, stylesheets and metadata from I<path/to/epubdir>, to
create a EPUB file.

=cut

use strict;
use warnings;
use constant DEBUG=>0;
use lib ("lib","../lib");
use File::Spec;
use Perldoc::Names;
if(DEBUG) {
	require Data::Dumper;
}

=head1 OPTIONS

=over 8

=cut

=item B<< --help >>

Print a brief help message and exit.

=item B<< --manual >>

View application manual

=item B<< --output/--epub >>

This option sets the name of the EPUB file the program will create.

If it is missing the suffix I<< .epub >> is added to I<< path/to/epubdir >>
and used as the name of the EPUB file.

=item B<< --author >>

This option sets the dc:creator attribute of the metadata.
You may use this for information about the author.

=item B<< --cover >>

This option marks the file containing the cover for the OPF guide.

=item B<< --id >>

Set the I<dc:identifier> for the metadata.

=item B<< --lang >>

Set the I<dc:language> for the metadata. Defaults to I<en>.

=item B<< --publisher >>

This option sets the dc:publisher attribute of the metadata.
You may use this for information about the publisher.

=item B<< --rights >>

This options sets the dc:rights attribute of the metadata.
Use this for copyright information.

=item B<< --title >>

Set the I<dc:title> for the metadata.

=back
=cut
my @OPTIONS = qw/
	help|h
	manual|man
	title|t=s
	output|epub|o=s
	source|s=s
	author|a=s
	cover|c=s
	id|i=s
	lang|l=s
	creator=s
	rights|r=s
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

my $SOURCE = shift(@ARGV) || $OPTS{source};
my $OUTPUT;
my $TITLE = $OPTS{title};
if($OPTS{output}) {
	$OUTPUT = $OPTS{output};
}
else {
	$OUTPUT = shift(@ARGV);
}
if(!$OUTPUT) {
	$OUTPUT = $SOURCE;
	$OUTPUT =~ s/^.*[\/\\]([^\/\\]+)$/$1/;
	$OUTPUT .= ".epub";
}
if(!$TITLE) {
	$TITLE = $OUTPUT =~ s/\.epub$//r;
}

die("Directory not exist: $SOURCE\n") unless(-d $SOURCE);
my $DH;
opendir $DH,$SOURCE or die("Error: open directory $SOURCE failed:$!\n");

sub catfile {
	return File::Spec->catfile($SOURCE,@_);
}

sub expand_file {
	return (catfile($_[0]),$_[0]);
}
use EBook::EPUB;
my $epub = EBook::EPUB->new();

my $ORDER=0;
sub add_content {
	my $name = shift;
	my $filename = shift;
	my $data = shift;
	my $id;
	print STDERR "\r<< $filename                    ";
	if($data) {
		$id = $epub->add_xhtml($filename,$data);
	}
	else {
		$id = $epub->copy_xhtml(expand_file($filename));
	}	
	$ORDER++;
	$epub->add_navpoint(
		label=>$name,
		id=>$id,
		content=>$filename,
		play_order=>$ORDER,
	);
	return $id;
}
sub add_file {
	my $name = shift;
	my $filename = catfile($name);
	my $mimetype = `file -b --mime-type "$filename"`;chomp($mimetype);
	print STDERR "\r<< $name                        ";
	return $epub->copy_file($filename,$name,$mimetype);
}

sub add_cover {
	print STDERR "\r<< [COVER] @_                ";
	my $id = add_file(@_);
	return $epub->add_meta_item('cover',$id);
}

$epub->add_title($TITLE);
$epub->add_author($OPTS{author} || "perl.org");
$epub->add_creator($OPTS{creator} || "xiaoranzzz");
$epub->add_date(scalar(localtime));
$epub->add_description("manual for Perl");
$epub->add_subject("perl");
$epub->add_type("programming");
$epub->add_language($OPTS{lang} || 'en');
$epub->add_rights($OPTS{rights} || 'unknown');
$epub->copy_stylesheet(expand_file("perldoc.css"));

my @Lnames;
my @Unames;
my @otherfiles;
my %htmlfiles;
my %cached;
my $SORTED = $PERLDOC_NAMES->{sorted}; 
my $cover;

my @all = sort(readdir $DH);
foreach(@all) {
	if(m/^(.+)\.html$/) {
		my $name = $1;
		$name =~ s/(.)_/$1::/g;
		if($name =~ m/^[A-Z]/) {
			push @Unames,$name;
		}
		else {
			push @Lnames,$name;
		}
		$htmlfiles{$name} = $_;
	}
	elsif(-f catfile($_)) {
		if(m/^cover.*\.(?:jpg|png|jpeg)$/i) {
			$cover = $_;
		}
		else {
			push @otherfiles,$_;
		}
	}
}
if($cover) {
	add_content("cover","cover.html",
		<<"HTML"
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html>
<head>
<title>Cover</title>
<link rel="stylesheet" href="perldoc.css" type="text/css" />
</head>
<body id="_podtop_">
<img src="$cover"></img>
<p>
$TITLE
</p>
</body>
</html>

HTML
	);
	add_cover($cover);
}

#$epub->pack_zip($OUTPUT) or die();;
#die();

print STDERR "\n";
foreach(@otherfiles) {
	add_file($_);
}
foreach(@$SORTED) {
	if($htmlfiles{$_}) {
		add_content($_,$htmlfiles{$_});
		$cached{$_} = 1;
	}
	else {
		#print STDERR "\nNo file found for name [$_], ignored.\n";
	}
}
foreach(@Lnames,@Unames) {
	next if($cached{$_});
	if(DEBUG) {
		print STDERR "\nUnsorted name: $_\n";
	}
	add_content($_,$htmlfiles{$_});
}

print STDERR "\n";
print STDERR "Creating $OUTPUT ...";
$epub->pack_zip($OUTPUT) or die();;
print STDERR "\t[OK]\n";


__END__

=head1 DESCRIPTION

This program will generate perldoc EPUB book, from 
html related files in the directory specified.

=head1 AUTHOR

Eotect Nahn <eotect#donot.sendme.email>

=cut

