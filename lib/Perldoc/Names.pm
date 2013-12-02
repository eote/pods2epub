package Perldoc::Names;
BEGIN {
    require Exporter;
    our ($VERSION,@ISA,@EXPORT,@EXPORT_OK,%EXPORT_TAGS);
    $VERSION        = 1.00;
    @ISA            = qw(Exporter);
    @EXPORT      = qw($PERLDOC_NAMES);
}

our $PERLDOC_NAMES = {};
for($PERLDOC_NAMES) {
	$_->{faq} = [qw'
		perlfaq
		perlfaq1
		perlfaq2
		perlfaq3
		perlfaq4
		perlfaq5
		perlfaq6
		perlfaq7
		perlfaq8
		perlfaq9
	'];
	$_->{overview} = [qw'
		perl
		perlintro
		perltoc
	'];
	$_->{tutorials} = [qw'
		perlreftut
		perldsc
		perllol

		perlrequick
		perlretut

		perlboot
		perlbot
		perlootut
		perltoot
		perltooc

		perlothrtut

		perlperf

		perlstyle
		
		perlcheat
		perltrap
		perldebtut
	'];
	$_->{reference} = [qw'
        perlsyn
        perldata
        perlop
        perlsub
        perlfunc
        perlopentut
        perlpacktut
        perlpod
        perlpodspec
        perlpodstyle
        perlrun
        perldiag
        perllexwarn
        perldebug
		perldtrace
        perlvar
        perlre
        perlrebackslash
        perlrecharclass
        perlreref
        perlref
        perlform
        perlobj
        perltie
        perldbmfilter

        perlipc
        perlfork
        perlnumber

        perlthrtut

        perlport
        perllocale
        perluniintro
        perlunicode
        perlunifaq
        perluniprops
        perlunitut
        perlebcdic

        perlsec

        perlmod
        perlmodlib
        perlmodstyle
        perlmodinstall
        perlnewmod
        perlpragma

        perlutil

        perlcompile

        perlfilter

        perlglossary

	'];
	$_->{internal} = [qw'
		perlembed
		perldebguts
		perlxstut
		perlxs
		perlxstypemap
		perlclib
		perlguts
		perlcall
		perlmroapi
		perlreapi
		perlreguts
		
		perlapi
		perlintern
		perliol
		perlapio
		
		perlhack
		perlsource
		perlinterp
		perlhacktut
		perlhacktips
		perlpolicy
		
		perlgit
		perlrepository
	'];
	$_->{misc} = [qw'
		perlbook
		perlcommunity
		perltodo
		
		perldoc
		
		perlhist
		perldelta
		perl5181delta
		perl5180delta
		perl5163delta
		perl5162delta
		perl5161delta
		perl5160delta
		perl5144delta
		perl5143delta
		perl5142delta
		perl5141delta
		perl5140delta
		perl51311delta
		perl51310delta
		perl5139delta
		perl5138delta
		perl5137delta
		perl5136delta
		perl5135delta
		perl5134delta
		perl5133delta
		perl5132delta
		perl5131delta
		perl5130delta
		perl5125delta
		perl5124delta
		perl5123delta
		perl5122delta
		perl5121delta
		perl5120delta
		perl5115delta
		perl5114delta
		perl5113delta
		perl5112delta
		perl5111delta
		perl5110delta
		perl5101delta
		perl5100delta
		perl595delta
		perl594delta
		perl593delta
		perl592delta
		perl591delta
		perl590delta
		perl589delta
		perl588delta
		perl587delta
		perl586delta
		perl585delta
		perl584delta
		perl583delta
		perl582delta
		perl581delta
		perl58delta
		perl573delta
		perl572delta
		perl571delta
		perl570delta
		perl561delta
		perl56delta
		perl5005delta
		perl5004delta
		
		perlexperiment

		perlartistic
		perlgpl
	'];
	$_->{lang} = [qw'
		perlcn
		perljp
		perlko
		perltw
	'];
	$_->{platform} = [qw'
		perlaix
		perlamiga
		perlapollo
		perlbeos
		perlbs2000
		perlce
		perlcygwin
		perldgux
		perldos
		perlepoc
		perlfreebsd
		perlhaiku
		perlhpux
		perlhurd
		perlirix
		perllinux
		perlmacos
		perlmacosx
		perlmachten
		perlmint
		perlmpeix
		perlnetware
		perlopenbsd
		perlos2
		perlos390
		perlos400
		perlplan9
		perlqnx
		perlriscos
		perlsolaris
		perlsymbian
		perltru64
		perluts
		perlvmesa
		perlvms
		perlvos
		perlwin32
	'];
	$_->{pragmas} = [qw'
		attributes
		autodie
		autouse
		base
		bigint
		bignum
		bigrat
		blib
		bytes
		charnames
		constant
		diagnostics
		encoding
		feature
		fields
		filetest
		if
		integer
		less
		lib
		locale
		mro
		open
		ops
		overload
		overloading
		parent
		re
		sigtrap
		sort
		strict
		subs
		threads
		threads::shared
		utf8
		vars
		vmsish
		warnings
		warnings::register
	'];
	$_->{modules} = [qw'
		AutoLoader
		Carp
		Carp::Heavy
		Cwd
		DynaLoader
		Errno
		Exporter
		Exporter::Heavy
		Fcntl
		File::Glob
		File::Spec
		File::Spec::Unix
		FileHandle
		Getopt::Long
		Hash::Util
		IO
		IO::File
		IO::Handle
		IO::Pipe
		IO::Seekable
		IO::Select
		IO::Socket
		IO::Socket::INET
		IO::Socket::UNIX
		IPC::Open2
		IPC::Open3
		List::Util
		Scalar::Util
		SelectSaver
		Socket
		Symbol
		Text::ParseWords
		Text::Tabs
		Text::Wrap
		Tie::Hash
		UNIVERSAL
		XSLoader
	'];
	$_->{basic} = [
		@{$_->{overview}},
		@{$_->{tutorials}},
		@{$_->{reference}},
		@{$_->{internal}},
		@{$_->{pragmas}},
		@{$_->{misc}},
		@{$_->{platform}},
		@{$_->{lang}},
		@{$_->{faq}},
	];
	$_->{sorted} = [
		@{$_->{basic}},
	];
}

1;

