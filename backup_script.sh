#!/usr/bin/env bash

# Directories to do the backup
backup_path=("/home/gabriel/Downloads" "/home/gabriel/www" "/home/gabriel/binaries")
backup_path_dir=("downloads" "www" "binaries")

# Storage where the backup is made
storage="/mnt/backup"

# Formating the backup archive name
date_format=$(date "+%d-%m-%Y")

# Log file name
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



