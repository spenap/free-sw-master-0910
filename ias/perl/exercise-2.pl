#!/usr/bin/perl -w

print "Type number 1/4: ";
$a = <STDIN>; chomp($a);

push(@list, $a);

print "Type number 2/4: ";
$b = <STDIN>; chomp($b);

push(@list, $b);

print "Type number 3/4: ";
$c = <STDIN>; chomp($c);

push(@list, $c);

print "Type number 4/4: ";
$d = <STDIN>; chomp($d);

push(@list, $d);

@sorted = sort { $a <=> $b } @list;

print "Thanks, your numbers are: @sorted\n";
