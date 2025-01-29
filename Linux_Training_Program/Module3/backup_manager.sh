#!/bin/bash

# Creates a source directory if does not exists
mkdir -p "$1"

#  Creates backup directory if backup directory does not exists
if [ ! -d "$2" ]; then
	echo "Backup Directory does not exist, creating one..."
	if mkdir -p "$2"; then
		echo
	else
		echo "Backup directory couldn't be created"
		exit
	fi
fi

if [ ! -z "$(find "$1" -empty)" ]; then
	find "$1" -empty
	echo "above files/directories are empty. Aborting..."
	exit
fi

# Array operations
echo "______________________________________________"

declare -a backup_array
export BACKUP_COUNT
BACKUP_COUNT=0
for file in "$1"/*"$3"; do
	base_file=$(basename ${file})
	backup_array+=("$base_file")
	filesize=$(stat -c %s "$file") 
	echo "$base_file | $filesize Bytes"
done

echo "______________________________________________"

#Create backup
files_proc=0
total_size=0
for file1 in "$1"/*"$3"; do
	flag=1
	base_file1=$(basename $file1)
	files_proc=$(($files_proc + 1))
	echo "Source dir file - $file1"
	if [[ ! -z "$(ls -A "$2"/)" ]]; then
		for file2 in "$2"/; do
			echo "Backup dir file - $file2"
			base_file2=$(basename $file2)
			if [[ "$base_file1"="$base_file2" ]]; then
				if [[ "$file1" -nt "$file2" ]]; then
					cp "$file1" "$file2"
					echo "Backup Created for $base_file1"
					BACKUP_COUNT=$(($BACKUP_COUNT+1))
					backup_size=$(stat -c %s "$file2") 
					total_size=$(($total_size+$backup_size))
					flag=0
				fi
			fi
		done
		if [ $flag -eq 1 ]; then
			cp "$file1" "$2"/"$base_file1"
			echo "Backup Created for $base_file1"
			BACKUP_COUNT=$(($BACKUP_COUNT+1))
			backup_size=$(stat -c %s "$file1") 
			total_size=$(($total_size+$backup_size))
		fi
	else
		cp "$file1" "$2"/"$base_file1"
		echo "Backup Created for $base_file1"
		BACKUP_COUNT=$(($BACKUP_COUNT+1))
		backup_size=$(stat -c %s "$file1") 
		total_size=$(($total_size+$backup_size))
	fi

done		
echo "______________________________________________"
echo "Number of files backed up = $BACKUP_COUNT"

echo "______________________________________________"

#Output report

echo "Total files processed => $files_proc Files" > "$2"/backup_report.log
echo "Total size backed up => $total_size Bytes" >> "$2"/backup_report.log
echo "Backup Directory => $2" >> "$2"/backup_report.log
