package Perldoc;


BEGIN {
    require Exporter;
    our ($VERSION,@ISA,@EXPORT,@EXPORT_OK,%EXPORT_TAGS);
    $VERSION        = 1.00;
    @ISA            = qw(Exporter);
	@EXPORT_OK		= qw/&perldoc_search &perldoc_files/;
}

use File::Spec;


sub perldoc_search {
	my $query = shift;
	if(!@_) {
		my $filename = `perldoc -l "$query"`;
		chomp($filename) if($filename);
		return $filename if($filename);
		return;
	}
	foreach my $ext (qw/.pod .pm/) {
		foreach my $dir (@_) {
			my $filename = File::Spec->catfile($dir,"$query$ext");
			if(-f $filename) {
				return $filename;
			}
			$filename = File::Spec->catfile($dir,"pod","$query$ext");
			if(-f $filename) {
				return $filename;
			}
		}
	}
}

use File::Glob qw/bsd_glob/;
sub _lookup {
	my $dir = shift;
	my $prefix = shift;
	my @r;
	opendir(my $dh,$dir) or return;
	
	my @files;
	my @dirs;
	FILE:
	while(readdir $dh) {
		next FILE if(m/^\.+$/);
		if(-f File::Spec->catfile($dir,$_) and m/\.(?:[Pp][Oo][Dd]|[Pp][Mm])$/) {
			push @files,$_;
		}
		elsif(-d File::Spec->catdir($dir,$_)) {
			push @dirs,$_;
		}
	}
	foreach(@files) {
		push @r,($prefix ? File::Spec->catfile($prefix,$_) : $_);
	}
	foreach(@dirs) {
		push @r,_lookup(File::Spec->catdir($dir,$_),($prefix ? File::Spec->catfile($prefix,$_) : $_));
	}
	return @r;
}

sub perldoc_files {
	my @r;
	my %uname;
	foreach my $dir (@_) {
		foreach my $name (_lookup($dir,"")) {
			if($uname{$name}) {
				print STDERR "Name conflicted: $name [$dir] ingored\n";
			}
			else {
				$uname{$name} = File::Spec->catfile($dir,$name);
			}
		}
	}
	foreach my $filename (keys %uname) {
			my $mod = $filename;
			$mod =~ s/\//::/g;
			my $ext;
			if($mod =~ m/^(.+)\.([Pp][Mm]|[Pp][Oo][Dd])$/) {
				$mod = $1;
				$ext = lc($2);
			}
			else {
				next;
			}
			if($ext eq 'pm' and $uname{$mod . ".pod"}) {
				print STDERR "Name conflicted: $filename ignored\n";
				next;
			}
			if($mod =~ m/^[Pp][Oo][Dd][Ss]?::([a-z0-9_]+.+)$/) {
				$mod = $1;
			}
			push @r,[$mod,$uname{$filename}];
	}
	return @r;

}
1;

