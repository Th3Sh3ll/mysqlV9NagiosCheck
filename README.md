# mysqlV9NagiosCheck
MySQL Server Nagios Check for MySQL ver: >9

If you have NagiosXI installed , make the change in the following file:

/usr/local/nagios/libexec/check_mysql_health

# why
Seems Nagios Xi are still catering for MySQL version 9 and above where MySQL have dropped the Master/Slave use and replaced with "replica" and "source"