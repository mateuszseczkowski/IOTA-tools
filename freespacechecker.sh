#!/bin/bash
CURRENT_DATABASE_SPACE_TAKEN=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
THRESHOLD_TO_SEND_EMAIL=90
THRESHOLD_TO_DELETE_DB=93
EMAIL_TEXT=""
DB_DIRECTORY="/var/lib/iri/target/mainnetdb"

if [ "$CURRENT_DATABASE_SPACE_TAKEN" -gt "$THRESHOLD_TO_SEND_EMAIL" ] ; then
    EMAIL_TEXT+='Your root partition remaining free space is critically low';
	echo "Remaining free space is critically low.";
fi

if [ "$CURRENT_DATABASE_SPACE_TAKEN" -gt "$THRESHOLD_TO_DELETE_DB" ] && [ -d "$DB_DIRECTORY" ] ; then
	EMAIL_TEXT+='. \n Need to delete database occured.';
	echo "Removing database...";
	echo "`systemctl \stop iri && rm -r $DB_DIRECTORY && systemctl start iri`"
	if [ ! -d "$DB_DIRECTORY" ]; then
		echo "Database removed.";
		EMAIL_TEXT+=' Database has been removed.'
	fi
fi

if [ ! -z "$EMAIL_TEXT" ] ; then
	echo "Sending email...";
	mail -s 'Disk Space Alert IotaFieldNode_ms2' youremailaddress@example.com << EOF
$EMAIL_TEXT. Used: $CURRENT_DATABASE_SPACE_TAKEN%
EOF
	echo "Email sent."
else 
	echo "`logger FreeSpaceChecker: root partition remaining free space is sufficient.`";
	echo "Root partition remaining free space is sufficient and is: $CURRENT_DATABASE_SPACE_TAKEN";
fi
