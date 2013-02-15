#!/usr/bin/perl -w

open(PASSWD, "/etc/passwd") or die "Unable to open /etc/passwd\n";

@content = <PASSWD>;
close(PASSWD);

foreach $line (@content) {

	@tokens = split(/:/,$line);
	
	($user, undef, $id, undef) = @tokens;
	#($user, $id) = @tokens[0,2];
	
	print "The user ID of $user is $id\n";
}
