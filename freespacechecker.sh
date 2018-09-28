#!/bin/bash
current_database_space_taken=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
threshold_to_send_email=90
threshold_to_delete_db=93
email_text=""
db_directory="/var/lib/iri/target/mainnetdb"

if [ "$current_database_space_taken" -gt "$threshold_to_send_email" ] ; then
    email_text+='Your root partition remaining free space is critically low';
	echo "Remaining free space is critically low.";
fi

if [ "$current_database_space_taken" -gt "$threshold_to_delete_db" ] && [ -d "$db_directory" ] ; then
	email_text+='. \n Need to delete database occured.';
	echo "Removing database...";
	echo "`systemctl \stop iri && rm -r $db_directory && systemctl start iri`"
	if [ ! -d "$db_directory" ]; then
		echo "Database removed.";
		email_text+=' Database has been removed.'
	fi
fi

if [ ! -z "$email_text" ] ; then
	echo "Sending email...";
	mail -s 'Disk Space Alert IotaFieldNode_ms2' youremailaddress@example.com << EOF
$email_text. Used: $CURRENT_DATABASE_SPACE_TAKEN%
EOF
	echo "Email sent."
else 
	echo "`logger FreeSpaceChecker: root partition remaining free space is sufficient.`";
	echo "Root partition remaining free space is sufficient: $((100 - $current_database_space_taken))%";
fi
