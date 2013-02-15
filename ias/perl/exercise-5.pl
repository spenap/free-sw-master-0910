#!/usr/bin/perl -w

$src_name=$ARGV[0] or die "Source filename missing";
$dst_name=$ARGV[1] or die "Destination filename missing";

open(SRC, $src_name) or die "Unable to read source file";
open(DST, ">" . $dst_name) or die "Unable to write destination file";

@src_content=<SRC>;
close(SRC);

$count = $#src_content+1;

print DST reverse(@src_content);
close(DST);

print "Done! The file had $count lines\n";
