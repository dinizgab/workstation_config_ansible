#!/usr/bin/env bash

# Directories to do the backup
backup_path=("Put here the files you want to backup")
backup_path_dir=("Put here the files name you want to format")
# The two arrays should have the same length

# Storage where the backup is made
storage="/mnt/backup"

# Formating the backup archive name
date_format=$(date "+%d-%m-%Y")

# Log file name
if ! cd /var/log/backup; 
then
	mkdir /var/log/backup/
fi
log_file="/var/log/backup/backup.log"


# Checking if the mountpoint is mounted
#if ! mountpoint -q -- $storage;
#	then printf "[$date_format] Device not mounted in: $storage.\n" >> $log_file
#	exit 1
#fi

#######################
# Starting the backup #
#######################
for i in "${!backup_path[@]}"
do
	archive="backup-${backup_path_dir[$i]}-$date_format.tar.gz"
	
	printf "Backing up ${backup_path[$i]} to $storage\n"
	printf "[DATE] - "
	date
	printf "\n"

	if tar -czSpf "$storage/$archive" "${backup_path[$i]}";
		then printf "[$date_format] - ${backup_path[$i]} backed up with sucess!\n" >> $log_file
	else
		printf "[$date_format] - An error ocurred backing up ${backup_path[$i]} | code $?\n" >> $log_file
	fi 
done

find $storage -mtime +7 -delete 

printf "Backup finished!"



