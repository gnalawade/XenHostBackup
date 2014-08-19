#!/bin/sh
xenhostname=`xe host-list |grep name-label | awk '{print $4}'`
backupdir="/mnt/nfs/$xenhostname"
daten=`date +%d-%m-%g`
file_backup_name=$backupdir$xenhostname"-"$daten.xbk
database_backup_name=$backupdir$xenhostname"-"$daten"-database-dump"
metada_backup_name=$backupdir$xenhostname"-"$daten"-vm-metadata"
#echo $file_backup_name
mount -t nfs uds-srv03.sv.ua:/netbackup/XenServerHostBackup/ /mnt/nfs/
#
xe host-backup host=$xenhostname file-name=$file_backup_name
xe pool-dump-database file-name=$database_backup_name
for vmuuid in $(xe vm-list params=uuid is-control-domain=false|grep "uuid"|cut -c 17-) ; do
    xe vm-export metadata=true uuid=${vmuuid}  filename=$metada_backup_name.${vmuuid}
done
#
umount /mnt/nfs
