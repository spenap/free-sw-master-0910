#/bin/bash

OLDIFS=$IFS
IFS=$'\n'

function usage () {
 
 echo "`basename $0`: syntax error. Try the following:"
 echo "`basename $0` originalfile newfile"
 echo "`basename $0` -r originalpattern newpattern directory"

}

if [ 2 -eq "$#" -a "-r" != "$1" ]
then
   mv "$1" "$2"
elif [ 4 -eq "$#" -a "-r" = "$1" ]
then
 echo "Replacing pattern $2 by pattern $3 through $4"
 for file in `find $4 -type f -name "*$2*"`
 do
  FILENAME=`basename $file`
  PATHNAME=`dirname $file`
  NEWNAME=`echo $FILENAME | sed -ne "s|$2|$3|gp"`
  mv "$PATHNAME/$FILENAME" "$PATHNAME/$NEWNAME"
 done
 for file in `find $4 -type d | sort -r`
 do
  FILENAME=`basename $file`
  PATHNAME=`dirname $file`
  NEWNAME=`echo $FILENAME | sed -ne "s|$2|$3|gp"`
  if [ $NEWNAME ]
  then
   mv "$PATHNAME/$FILENAME" "$PATHNAME/$NEWNAME"
  fi
 done
else 
 usage
fi
