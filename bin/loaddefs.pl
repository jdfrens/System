#!/usr/bin/perl -w

use strict;

my @files = ();

my $dir = "./";
while (-e $dir) {
  my $file = $dir . "defs.latte";
  if (-e  $file) {
    unshift @files, $file;
  }
  $dir = $dir . "../";
}

open (OUTPUT, "| cpif loaddefs.lgen") || die "Cannot open loaddefs.lgen";
foreach my $file (@files) {
  print OUTPUT "\{\\load-file $file\}\n";
}
close OUTPUT;
