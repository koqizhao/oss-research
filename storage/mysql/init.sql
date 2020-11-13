
ALTER USER 'root'@'localhost' IDENTIFIED BY 'xx123456XX';

use mysql;
update user set host = '%' where user = 'root';
flush privileges;

ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'xx123456XX';
