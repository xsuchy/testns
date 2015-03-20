TL;DR for evaluation:
edit config.yml with your db credentials and run:
   ./bin/app.pl
and in broser navigate to:
   localhost:3000

== perl modules ==

Install those modules:

  - Dancer
  - ExtUtils::MakeMaker
  - Test::More
  - YAML
  - Dancer::Test
  - Dancer::Plugin::FlashMessage
  - FindBin
  - Plack::Runner

using 
  perl -MCPAN -e 'install Dancer ExtUtils::MakeMaker Test::More YAML Dancer::Test Dancer::Plugin::FlashMessage FindBin Plack::Runner'
or using packages from distrubution of your choice.

== DB setup ==

Install mariadb server and as privileged db user execute:

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

Put your DB settings into file config.yml in this git-root.

== Configure as web service ==

This applicatation can be run as CGI, FCGI or Plack.
You can integrate it using this document:
  https://metacpan.org/pod/Dancer::Deployment
I would suggest:
  https://metacpan.org/pod/Dancer::Deployment#Using-HAProxy
and put at the end:
  backend dynamic
    server app1 localhost:3000 check inter 30s
and run Dancer server using:
  ./bin/app.pl --daemon
or you can just run
  ./bin/app.pl
and have standalone server running on
  localhost:300
