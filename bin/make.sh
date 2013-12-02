#!/bin/sh
scrd=`dirname $0`

d=$1
shift
v=$1
shift
o_force=""
if [ -n "$1" ] ; then
	if [ "$1" == "-f" ] ; then
		o_force=1
	elif [ "$d" == "-f" ] ; then
		o_force=1
		d=$v
		v=$1
	elif [ "$v" == "-f" ] ; then
		o_force=1
		v=$1
	else
		echo "Usage: $0 [-f] <path/to/basedir> <version>"
		exit 2
	fi
fi

f="$d/$v"



for tv in "$d" "$v" ; do
	if [ -z "$tv" ] ; then
		echo "Usage: $0 <path/to/basedir> <version>"
		exit 2
	fi
done

for td in "$f" "$f/lib" ; do
	if [ ! -d "$td" ] ; then
		echo "Error, directory not accessable: $td"
		exit 1
	fi
done

if [ -n "$o_force" ] ; then
	echo -- perl "$scrd/make_xhtml.pl" --search "$f/lib/" "$f/xhtml"
	perl -- "$scrd/make_xhtml.pl" --search "$f/lib/" "$f/xhtml"
elif [ ! -d "$f/xhtml" ] ; then
	echo -- perl "$scrd/make_xhtml.pl" --search "$f/lib/" "$f/xhtml"
	perl -- "$scrd/make_xhtml.pl" --search "$f/lib/" "$f/xhtml"
fi

[ -f "$f/xhtml/perldoc.css" ] || touch "$f/xhtml/perldoc.css"

if [ -f "$f/perldoc-$v.epub" ] ; then
	rm -v "$f/perldoc-$v.epub"
fi

if [ -d "$f/xhtml" ] ; then
	echo -- perl "$scrd/make_epub.pl" --source "$f/xhtml" --title "Manual for Perl $v" --output "$f/perldoc-$v.epub"
	perl -- "$scrd/make_epub.pl" --source "$f/xhtml" --title "Manual for Perl $v" --output "$f/perldoc-$v.epub"
fi


