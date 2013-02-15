#!/usr/bin/perl -w

$fileName = $ARGV[0] or die "No filename given";

open(INPUT, $fileName) or die "Unable to open file: $fileName\n";

@content = <INPUT>;
close(INPUT);

foreach $line (@content) {
	if ($line !~ /^Hide/) {
		$line =~ s/this/that/;
		print $line;
	}
}
