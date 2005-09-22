#!/usr/bin/perl -w

use strict;

my $attempt = 0;
foreach my $find (@ARGV) {
  $attempt = trytofind ($find);
  last if ($attempt);
}
if ($attempt) {
  print $attempt;
}
else {
  print STDERR "Cannot find: ", join (" ", @ARGV), "\n";
  exit 1;
}

sub trytofind {

  my ($find) = @_;

  return "./" if (-e $find);
  my $dir = "../";
  until (-e $dir . $find or not -e $dir) {
    $dir = "../" . $dir;
  }
  return (-e $dir) ? $dir : 0;

}
