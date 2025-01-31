#!/bin/bash

if [ $# != 1 ]; then
	echo "No input file given, aborting..."
	exit
fi

if [[ ! -e $1 ]]; then
	echo "No such file exists. Aborting"
	exit
fi

if [[ ! -r $1 ]]; then
	echo "File is not readable. Aborting"
	exit
fi

if [[ ! -s $1 ]]; then
	echo "File is empty. Aborting"
	exit
fi

begin=0
while read line; do
	if [[ $line == *'"frame.time"'* || $line == *'"wlan.fc.type"'* || $line == *'"wlan.fc.subtype"'* ]]; then
		if [ $begin -eq 0 ]; then
			echo $line > "output.txt"
			begin=1
		else
			echo $line  >> "output.txt"
		fi
	fi
done < $1

echo "Output file has been written."
