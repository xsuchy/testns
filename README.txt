
== DB setup ==

use mysql;
create database testns;
create user 'mirek'@'localhost' identified by 'foobar';
grant all on testns.* to 'mirek'@'localhost';
flush privileges;

create table `nodes` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `parent` int(10) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `parent_key` (`parent`)
);

# we can use foreing keys for better integrity, but it can be used only in
# InnoDB table type.

INSERT INTO `nodes` (`id`, `parent`) VALUES
(1, 0),
(2, 1),
(3, 1);
