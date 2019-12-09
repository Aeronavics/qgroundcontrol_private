#!/bin/bash
a=`find site -name '*' -type f`
for filename in $a;do
    echo $filename
    curl -v --user $1 --upload-file $filename $2$filename
done
