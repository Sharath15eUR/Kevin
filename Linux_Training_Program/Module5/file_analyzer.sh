#!/bin/bash

# Name = J Kevin Immanuel
# College - VIT Chennai

# Finding word in file using here-string
find_herestring(){
	filename=$1
	key=$2
	linecount=0
	if [[ ! -e "$filename" ]]; then
		echo "No such file found : $filename" >> error.log
		exit 1
	fi
	
	if grep -q "$key" <<< "$(cat "$filename")"; then
		echo ""$key" Found"
		exit 0
	fi
	echo "No such word found"
	exit 0
}

find_wordfile(){
	directory=$1
	key=$2
	for file in "$directory"/*; do
		if [[ -d "$file" ]]; then
			find_wordfile "$file" "$key"
		fi
		
		if [[ -f "$file" ]]; then
			if grep -q "$key" <<< "$(cat "$file")"; then
				echo ""$key" Found in $file"
				exit 0
			fi
		fi
	done
}

# Here document for help menu

help_menu(){
cat << END
HELP MENU
_________
-d = directory
-f = filename
-k = keyword to search for
--help = help menu
END
}

if [[ "$1" == "--help" ]]; then
	help_menu
	exit 0
fi
while getopts "d:f:k:" flags 2>> error.log; do
	case $flags in
		d)
			dir=$OPTARG
			if [[ ! -d $dir ]]; then
				echo "No such directory found : "$dir"" >> error.log
				exit 1
			fi
			choice=1
			;;
		f)
			filename=$OPTARG
			choice=2
			;;
		k)
			keyword=$OPTARG
			#echo "$keyword"
			;;
		*)
			echo "INVALID ARGUMENT"
			help_menu
			exit 1
			;;
	esac
done

if [[ choice -eq 2 ]]; then
	find_herestring $filename $keyword
elif [[ choice -eq 1 ]]; then
	find_wordfile "$dir" "$keyword"
fi
