#!/usr/bin/perl -w

=head1 Name

	Perldoc::XHTML

=head1 Description

	Converter which converting POD to XHTML

=cut

package Perldoc::XHTML;
use strict;
use warnings;
BEGIN {
    require Exporter;
    our ($VERSION,@ISA,@EXPORT,@EXPORT_OK,%EXPORT_TAGS);
    $VERSION        = 1.00;
    @ISA            = qw(Exporter);
=head1 Exports	

	parse_file(), parse_string() and parse_lines

=cut
    @EXPORT      = qw(&parse_file &parse_string $parse_lines);
}

use Pod::Simple::XHTML;

#fix html
sub _postfix {
	$_[0] =~ s/href="(.+)::(.+)(?!=\.html$)"/href="$1_$2.html"/g;
	$_[0] =~ s/href="(.+)::(.+)(?!=\.html$)"/href="$1_$2.html"/g;
	$_[0] =~ s/href="([^"]+)#([^#]+)(\.html)"/href="$1$3#$2"/g;
	$_[0] =~ s/::(?=[^"]+\.html")/_/g;
	return $_[0];
}
sub _set_options {
	my $psx = shift;
	$psx->html_doctype(<<'DOCTYPE'
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
DOCTYPE
	);
	$psx->perldoc_url_prefix("");
	$psx->perldoc_url_postfix(".html");

	$psx->html_header_tags(<<'HEADER'

		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" href="perldoc.css" type="text/css" />

HEADER
	);
	$psx->index(0);
	$psx->anchor_items(1);
	$psx->backlink(1);
	$psx->no_errata_section(1);
	return $psx;
}

=head1 Methods

=over

=item L<parse_file( $some_filename )>

=item B<parse_file( *$INPUT_FH) >

	 This reads the Pod content of the file (or filehandle) that you
     specify, and parse it.

=cut

sub parse_file {
	my $psx = Pod::Simple::XHTML->new();
	my $r;
	_set_options($psx);
	$psx->output_string(\$r);
	$psx->parse_file($_[0]);
	return _postfix($r);
}


=item B<parse_string( $all_content )>

	This works just like "parse_file" except that it reads the Pod
    content not from a file, but from a string that you have already in
    memory.

=cut 

sub parse_string {
	my $psx = Pod::Simple::XHTML->new();
	my $r;
	_set_options($psx);
	$psx->output_string(\$r);
	$psx->parse_string_document($_[0]);
	return _postfix($r);
}
=item B<parse_lines( ...@lines...>

	This processes the lines in @lines (where each list item must be a
    defined value, and must contain exactly one line of content -- so
    no items like "foo\nbar" are allowed).

=cut

sub parse_lines {
	my $psx = Pod::Simple::XHTML->new();
	my $r;
	_set_options($psx);
	$psx->output_string(\$r);
	$psx->parse_lines(@_,undef);
	return _postfix($r);
}

=back
=cut



1;

