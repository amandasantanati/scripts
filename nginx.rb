#!/usr/bin/env ruby

# Creates a *.local file within nginx configuration given a project name

if ARGV.count == 1
  project = ARGV.first

  file = File.new "#{project}.local", 'w+'

  file.puts <<-config
  server {
    listen 80;
    charset utf-8;

    root /vagrant/#{project}/public;
    index index.php index.html index.htm;

    server_name #{project}.local;

    access_log /var/log/nginx/#{project}.local-access.log;
    error_log  /var/log/nginx/#{project}.local-error.log error;

    location / {
      try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { log_not_found off; access_log off; }

    error_page 404 /index.php;

    # include HHVM configuration (FastCGI)
    include hhvm.conf;

    # Deny .htaccess file access
    location ~ /\.ht {
      deny all;
    }
  }

  config
else
  puts 'You must type project name ONLY!'
end
