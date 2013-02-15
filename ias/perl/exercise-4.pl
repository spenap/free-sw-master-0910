#!/usr/bin/perl -w

@a = (
 { name => "Manolo", age => 25 },
 { name => "Sara", age => 34 }
);

foreach $var (@a) {
	%entry=%{$var};
	print "$entry{name} is $entry{age} years old \n";
}
