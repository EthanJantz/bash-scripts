#!/bin/bash
file1="file1"
for FILE in *; do
	if ! cmp --silent "$file1" "$FILE"; then
		#echo "$FILE differs"
		wrongfile=$FILE
		break
	fi
done

word=$(wdiff $file1 $wrongfile | grep -Po "{\+.*\+}" | grep -Po "[a-zA-Z]+")
echo $word

