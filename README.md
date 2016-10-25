Using vagrant with ansible and Symfony project
=


Project structure for this vagrant:
-

    <root_folder>/project

    <root_folder>/vagrant
    

Up Box
-

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
-

* Ubuntu Precise Pangolin (12.04) [LTS] 32
* memory: 1024
* ip: 12.18.56.95
* shared folder: /project to /var/www/project
* timezone: UTC
* nginx, DocRoot: /var/www/project, ServerName: project.vagrant
* php7 (modules: php7.0-cli, php7.0-intl, php7.0-mcrypt, php7.0-curl, php7.0-gd, php7.0-imap, php7.0-mysql | options: short_open_tag=1, opcache.enable_cli=1)
* mysql (user: project, pass: project, dbname: project_dev)

Ansible Roles:
-
* server
* server_host
* symfony (move cache/logs to box, run commands during up)
* composer - run composer on box if you want move vendor libs to box
* php
* xdebug
* elasticsearch
* mongodb
* mysql
* nginx
* rabbitmq
* redis

Symfony improvement performance
-

1) Edit AppKernel:
        
        //project/app/AppKernel.php
        
        public function getRootDir()
        {
            return __DIR__;
        }
    
        /**
         * @return string
         */
        public function getCacheDir()
        {
            return !empty($envParams = $this->getEnvParameters()) && array_key_exists('kernel.cache_dir', $envParams)
                ? rtrim($envParams['kernel.cache_dir'], '/').'/'.$this->environment
                : dirname(__DIR__).'/var/cache/'.$this->getEnvironment();
        }
    
        /**
         * {@inheritdoc}
         *
         * @api
         */
        public function getLogDir()
        {
            return !empty($envParams = $this->getEnvParameters()) && array_key_exists('kernel.logs_dir', $envParams)
                ? $envParams['kernel.logs_dir']
                : dirname(__DIR__).'/var/logs';
        }
        
2) Move sessions files to box:


    # app/config.yml 
    framework:
        session:
            save_path:  "%kernel.sessions_dir%"


and     
    
    # app/parameters.yml
    kernel.sessions_dir: '/tmp/project/sessions/%kernel.environment%'