#! /bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
else
	command=$1
	echo "Execute $command"

	if [ $1 = "mpstat" ]; then
		echo "`mpstat`";
	elif [ $1 = "ls" ]; then
		echo "`ls -l`";
	elif [ $1 = "stats" ]; then
		echo "`journalctl -u iota -f`";
	elif [ $1 = "reboot?" ]; then
		echo "`ls -l /var/run/reboot-required`";
	elif [ $1 = "field" ]; then
		echo "`field`";
	elif [ $1 = "allowport" ]; then
		echo "`ufw allow \$2/\$3`";
	elif [ $1 = "iric" ]; then
		echo "`iric`";
	elif [ $1 = "df" ]; then
		echo "`df -H`";
	elif [ $1 = "tail" ]; then
		echo "`tail -50 /var/log/messages`";
	else 
		echo "Command $command not found. Try again.";
	fi
fi
#ufw status verbose
#	
# cd /tmp && wget -O iota.db.tgz https://x-vps.com/iota.db.tgz && systemctl \stop iri && rm -rf /var/lib/iri/target/mainnetdb* && mkdir /var/lib/iri/target/mainnetdb/ && pv iota.db.tgz | tar xzf - -C /var/lib/iri/target/mainnetdb/ && chown iri.iri /var/lib/iri -R && rm -f /tmp/iota.db.tgz && systemctl start iri

# $crontab -e 
#0 4  *   *   *    /sbin/shutdown -r +5
