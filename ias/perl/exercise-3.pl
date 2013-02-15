#!/usr/bin/perl -w

$a = [ 10, 45, 13, 53, 62 ];

@list = @{$a};

$d = $#list+1; # Manera en dos pasos: extracción y obtención de tamaño.
# $d = $#$a+1; Manera más comprimida, pero legible
# $d = @{$a}; Manera comprimida, pero obliga a saber que se interpreta
# la lista como el escalar de su tamaño

print "The number of elements in \$a is: $d\n"
