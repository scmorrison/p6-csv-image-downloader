#!/usr/bin/env perl6

use v6;

use Text::CSV;
use LWP::Simple;

# Read/parse CSV
my $csv = Text::CSV.new();
my $fh  = open "./products.csv", :r, chomp => False;

while (my @row = $csv.getline($fh)) {
  # mkdir category dir if doesn't exist
  if @row[0].IO !~~ :d { mkdir @row[0] }
  # Skip if ID is blank
  @row[1] !~~ "" or next;
  # Image file name
  my $file = @row[1].lc ~ ".jpg";
  # Download image
  my $prod_image = LWP::Simple.get("http://some-doman.com/path/" ~ $file);
  # Confirm we downloaded the file
  $prod_image.WHAT ~~ Buf[uint8] or next;
  # Write image
  say 'Preparing to write: ' ~ @row[0] ~ '/' ~ $file;
  spurt @row[0] ~ '/' ~ $file, $prod_image;
  say "File written: $file";
}

# Close the csv
$fh.close;
