CREATE USER replic@'%' IDENTIFIED WITH mysql_native_password BY 'sql';
GRANT REPLICATION SLAVE ON *.* TO replic@'%';