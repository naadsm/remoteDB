#!perl
# this script parses all the headers (.h) and designer (.ui) files in the
# current directory 
# - for each header that contains the Q_OBJECT macro, a moc_xxx.cpp file will
#   be created 
# - for each designer file a ui_xxx.h file will be created
# the script needs two parameters: 
#    1- the path to the moc executable
#    2- the path to the uic executable
# optionally you can put a '-v' parameter at before the path parameters and you
# will see some messages printed to the screen as the script runs
use strict;
use warnings;

# List all headers that need to be MOC'd here.
my @headers = (
	"E:/Atriplex/Atriplex-HEAD/atrShared/cqhttpserver.h",
	"E:/Atriplex/Atriplex-HEAD/atrShared/chttpserverclient.h",
	"cqmyhttpserver.h",
	"cqapplication.h"
);


# List all UI files here.
my @uis = (
	# This project has no UI files
);


# Get rid of any old junk.
unlink "moclib.a";

my $verbose = 0;


if ($#ARGV >= 1 && $ARGV[0] eq "-v") {
  $verbose = 1;
  shift(@ARGV);
}

if ($#ARGV < 1) {
  if ($verbose) { print "need to be passed the moc and uic executable paths\n"; }
  exit;
}

my $moc = shift(@ARGV);
if (!$verbose) { $moc .= ' -nw'; } # no moc warnings
my $uic = shift(@ARGV);

# search for the Q_OBJECT macro in all headers and create moc_xxx.cpp files
if ($verbose) { print "using $moc to create moc'd sources...\n"; }

while (my $h = shift(@headers)) {

	# print "HEADER $h\n";
	
  $h =~ /([a-zA-Z0-9]+\.)(h|cpp)/;  # do people moc cpp files?
  my $mocd = "moc_$1cpp";

  open F, $h or print "error opening $h\n";
  my $needs_moc = 0;
  while (defined(my $t = <F>) && !$needs_moc) {
    if ($t =~ m/^\s*Q_OBJECT.*/) {
       $needs_moc = 1; 
    }
  }
  close F;

  if ($needs_moc) {

    # moc only needs to be redone if the header has been changed more recently
    my $do_moc = 1;
    if (-e $mocd) {
      if ((stat($mocd))[9] > (stat($h))[9]) {
        $do_moc = 0;
      }
    }

    if ($do_moc) {
      if ($verbose) { print "moc'ing $h => $mocd\n"; }
      system("$moc $h -o $mocd");
    }
  } else {
    # if a moc_xxx.cpp exists, then the coder probably removed the Q_OBJECT and
    # we don't need it any more
    if (-e $mocd) {
      if ($verbose) { print "removing $mocd\n"; }
      unlink($mocd) 
    }
  }
}

# search for .ui files and run uic
if ($verbose) { print "using $uic to create uic'd headers...\n"; }

while (my $u = shift(@uis)) {
  $u =~ /([a-zA-Z0-9]+\.)ui/;
  my $uicd = "ui_$1h";

  my $do_uic = 1;
  if (-e $uicd) {
    if ((stat($uicd))[9] > (stat($u))[9]) {
      $do_uic = 0;
    }
  }

  if ($do_uic) {
    if ($verbose) { print "uic'ing $u => $uicd\n"; }
    system("$uic $u -o $uicd");
  }
}

