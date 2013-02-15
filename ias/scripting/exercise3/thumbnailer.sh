#!/bin/bash

function usage () {
 echo "`basename $0`: creates thumbnails for a given source directory on a mirrorized destination directory"
 echo "Usage:"
 echo "\$ `basename $0` source_dir destination_dir"
}

# Sanity checks
if [ $# -ne 2 ]
then 
 usage 
 exit
elif [ ! -d $1 ]
then
 echo "Source directory $1 doesn't exist"
 usage
 exit
fi

OLDIFS=$IFS
INITIALDIR=`pwd`
DSTDIR=`basename $1`
IFS=$'\n'

# Move to the source directory to avoid expansion problems
cd "$1"/..

# The directory structure is mirrored here
for entry in `find $DSTDIR -type d`
do
 mkdir -p "$INITIALDIR/$2/$entry"
done

# Image thumbnails are created here
for file in `find $DSTDIR -iname '*.jpg'`
do
 ORIGINAL_PATH=`dirname $file`
 REPLICATED_PATH="$INITIALDIR/$2/$ORIGINAL_PATH"
 EXTENSION=`echo $file | sed -ne 's/.*\(\..*\)$/\1/p'`
 THEFILE=`basename $file $EXTENSION` 

 echo "Creating thumbnail for $THEFILE..."
 convert "$file" -thumbnail x200 "$REPLICATED_PATH/$THEFILE"_thumbnail.jpg
done

