#!/usr/bin/perl -w

sub print_entry {

	my %entry = @_;
	
	print "The user ID of $entry{name} is $entry{id}\n";
}

open(PASSWD, "/etc/passwd") or die "Unable to open /etc/passwd\n";

@content = <PASSWD>;
close(PASSWD);

foreach $line (@content) {

	@tokens = split(/:/,$line);
	
	($user, undef, $id, undef) = @tokens;
	#($user, $id) = @tokens[0,2];
	
	print_entry ( name => $user, 
		id => $id ); 
}
