
ALTER USER 'root'@'localhost' IDENTIFIED BY 'MYSQL_PASSWORD';

use mysql;
update user set host = '%' where user = 'root';
flush privileges;

ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'MYSQL_PASSWORD';
