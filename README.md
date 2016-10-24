Using vagrant with ansible
========================


1) Composer install (more on [Installing (Use Composer)](#composer))
    
    cd ./project
    composer install    

2) Create env via Vagrant:
 
    cd ./vagrant
    vagrant up

4) add to you hosts:
 
    12.18.56.95 project.vagrant www.project.vagrant
     
5) on browser 

    http://12.18.56.95
    
    or
    
    http://project_demo.vagrant

On box:

* Ubuntu Precise Pangolin (12.04) [LTS] 32

* memory: 1024

* ip: 12.18.56.95

* shared folder: /project to /var/www/project

* timezone: UTC

* nginx, DocRoot: /var/www/project, ServerName: project.vagrant

* php7 (modules: php7.0-cli, php7.0-intl, php7.0-mcrypt, php7.0-curl, php7.0-gd, php7.0-imap, php7.0-mysql | options: short_open_tag=1, opcache.enable_cli=1)

* mysql (user: project, pass: project, dbname: project_dev)