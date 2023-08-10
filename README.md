# NetBackup zabbix template
**This template can track frozen jobs and pool status.
This template also checks the % usage of data pools.**

The script netbackssh.sh should be in **/usr/lib/zabbix/externalscript/netbackssh.sh**
The script long_jobs.pl should be in **/root ** on the netbackup master server.
You also have to generate an ssh key pair and pass it to the main server with zabbix (server | proxy) to use the command without a password.
