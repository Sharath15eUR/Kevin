#!/bin/bash

if [[ $# != 3 ]]; then
	echo "Not enough arguments. Aborting..."
	exit
fi

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

ext_flag=1
for file in "$1"/*; do
	if [[ $file == *$3 ]]; then
		ext_flag=0
		break
	fi
done

if [[ $ext_flag -eq 1 ]]; then
	echo "No such file of $3 extension in source. Aborting..."
	exit
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

#Create backup
files_proc=0
total_size=0
for file1 in "$1"/*"$3"; do
	flag=1
	base_file1=$(basename $file1)
	files_proc=$(($files_proc + 1))

	if [[ ! -z "$(ls -A "$2"/)" ]]; then
		for file2 in "$2"/*; do
			base_file2=$(basename $file2)
			#echo "________________________"
			#echo "Source file - $base_file1"
			#echo "Backup file - $base_file2"
			if [[ $base_file1 == $base_file2 ]]; then
				# echo "$file1 and $file2"
				if [[ "$file1" -nt "$file2" ]]; then
					cp "$file1" "$file2"
					backup_array+=("$base_file1")
					BACKUP_COUNT=$(($BACKUP_COUNT+1))
					backup_size=$(stat -c %s "$file2") 
					
					echo "$base_file1 | $backup_size Bytes"
					echo
					echo "Backup Created for $base_file1"
					
					total_size=$(($total_size+$backup_size))
					flag=0
				else
					echo "Backup file $base_file2 newer than source, not backing up"
					flag=0
					break
				fi
			fi
		done
		if [ $flag -eq 1 ]; then
			cp "$file1" "$2"/"$base_file1"
			backup_array+=("$base_file1")
			BACKUP_COUNT=$(($BACKUP_COUNT+1))
			backup_size=$(stat -c %s "$file1")
			echo "$base_file1 | $backup_size Bytes"
			echo
			echo "Backup Created for $base_file1"
			
			
			total_size=$(($total_size+$backup_size))
		fi
	else
		cp "$file1" "$2"/"$base_file1"
		backup_array+=("$base_file1")
		BACKUP_COUNT=$(($BACKUP_COUNT+1))
		backup_size=$(stat -c %s "$file1")
		echo "$base_file1 | $backup_size Bytes"
		echo
		echo "Backup Created for $base_file1"
		
		total_size=$(($total_size+$backup_size))
	fi

done		
echo "______________________________________________"
echo "Number of files backed up = $BACKUP_COUNT"

echo "______________________________________________"

#Output report

echo "Total files processed => $files_proc Files" > "$2"/backup_report.log
echo "Number of files backed up => $BACKUP_COUNT Files" >> "$2"/backup_report.log
echo "File names : " >> "$2"/backup_report.log
for file in "${backup_array[@]}"; do
	echo "$file" >> "$2"/backup_report.log
done
echo "Total size backed up => $total_size Bytes" >> "$2"/backup_report.log
echo "Backup Directory => $2" >> "$2"/backup_report.log



echo "______________________________________________"
echo "BACKUP REPORT:"
echo
cat "$2"/backup_report.log
