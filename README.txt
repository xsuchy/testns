
== DB setup ==

use mysql;
create database testns;
create user 'mirek'@'localhost' identified by 'foobar';
grant all on testns.* to 'mirek'@'localhost';
flush privileges;
