server {
    listen  80;

    root {{ nginx.docroot }};
    index {{ nginx.index }};

    server_name {{ nginx.servername }};

    location ~* \.(?:css|js|jpg?g|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc|ttf|ttc|otf|eot|woff|woff2)$ {
        access_log off;
        expires 1M;
        add_header Pragma public;
        add_header Cache-Control "public, must-revalidate, proxy-revalidate";
    }

    location / {
        try_files $uri $uri/ /{{ nginx.index }}$is_args$args;
    }

    error_page 404 /404.html;

    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        root /usr/share/nginx/www;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        fastcgi_index {{ nginx.index }};
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;

        include fastcgi_params;
    }

    access_log off;
    error_log /var/log/nginx/project_error.log;
}
