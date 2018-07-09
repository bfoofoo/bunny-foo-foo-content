require 'net/ssh'

module Deployer
  class BuilderService
    def initialize
    end

    def setup(config, host, user = 'sammy', password = "42Iknow42")
      Rails.logger.info 'setup'
      setup_host_data(host, user, password, config)
      clone_repo
      config[:type] == 'website' && create_config_file
      generate_static
      setup_bash
      setup_certbot
      set_beforessl_nginx_site
      restart_nginx
      generate_ssl
      set_afterssl_nginx_site
      restart_nginx
    end

    def rebuild(config, host, user = 'sammy', password = "42Iknow42")
      setup_host_data(host, user, password, config)
      pull_repo
      generate_static
      restart_nginx
    end

    private

    def setup_host_data(host, user, password, config)
      @host = host
      @user = user
      @password = password
      @config = config
    end

    def clone_repo
      Rails.logger.info @config[:repo_url]
      begin
        Net::SSH.start(@host, @user, password: @password) do |ssh|
          ssh.exec! "git clone --single-branch -b master #{@config[:repo_url]} autobuild"
          ssh.exec! "cd autobuild/; git checkout master"
          ssh.exec! "cd autobuild/; git fetch --all"
          ssh.exec! "cd autobuild/; git reset --hard origin/master"
        end
      rescue => error
        raise error
      end
    end

    def pull_repo
      begin
        Net::SSH.start(@host, @user, password: @password) do |ssh|
          ssh.exec! "cd autobuild/; git checkout master"
          ssh.exec! "cd autobuild/; git fetch --all"
          ssh.exec! "cd autobuild/; git reset --hard origin/master"
          ssh.exec! "cd autobuild/; npm install"
        end
      rescue
        raise 'Pull failed'
      end
    end

    def setup_certbot
      Rails.logger.info 'setup_certbot'
      begin
        Net::SSH.start(@host, @user, password: @password) do |ssh|
          ssh.exec! "git clone https://github.com/certbot/certbot"
        end
      rescue => error
        raise error
      end
    end

    def setup_bash
      Rails.logger.info 'setup_bash'
      begin
        bash_data_string = "'export LC_ALL=en_US.UTF-8'"
        bash_data_string_sec = "'export LC_CTYPE=en_US.UTF-8'"
        Net::SSH.start(@host, @user, password: @password) do |ssh|
          ssh.exec! "echo #{bash_data_string} >> ~/.profile; echo #{bash_data_string_sec}  >> ~/.profile; source ~/.profile"
        end
      rescue => error
        raise error
      end
    end

    def generate_ssl
      Rails.logger.info 'generate_ssl'
      result = ''
      Net::SSH.start(@host, @user, password: @password) do |ssh|
        channel = ssh.open_channel do |channel, success|
          channel.on_data do |channel, data|
            Rails.logger.info "SSH LOG: #{data} | "
            if data =~ /^\Do you want to continue / || data =~ /\[Y/
              channel.send_data "Y\n"
            elsif data =~ /^\[sudo\] password for /
              channel.send_data "#{@password}\n"
            elsif data =~ /too many certificates already issued for exact set of domain/
              raise "Generate ssl cert failed. Too many certificates already issued for exact set of domain #{@config[:name]}"
            elsif data =~ /error/
              raise 'Generate ssl cert failed'
            else
              result += data.to_s
            end
          end
          channel.request_pty
          channel.exec " source ~/.profile; cd ~/certbot; ./certbot-auto --agree-tos --renew-by-default --standalone --standalone-supported-challenges http-01 --http-01-port 9999 --server https://acme-v01.api.letsencrypt.org/directory certonly -d #{@config[:name]} -d www.#{@config[:name]}"
          channel.wait
        end
        channel.wait
      end
    end

    def create_config_file
      site_config = %Q{
        module.exports = {
          "'metaTitle'": "'#{@config[:name]}'",
          "'metaDescription'": "'#{@config[:description]}'",
          "'faviconImageUrl'": "'#{@config[:favicon_image]}'",
          "'logoImageUrl'": "'#{@config[:logo_image]}'",
          "'logoPath'": "'/logo.jpg'",
          "'email'": "'admin@#{@config[:name]}'",
          "'adClient'": "'#{@config[:ad_client]}'",
          "'adSidebar'": {
            "'type'": "'google'",
            "'id'": "'#{@config[:ad_sidebar_id]}'"
          },
          "'adTop'": {
            "'type'": "'google'",
            "'id'": "'#{@config[:ad_top_id]}'"
          },
          "'adMiddle'": {
            "'type'": "'google'",
            "'id'": "'#{@config[:ad_middle_id]}'"
          },
          "'adBottom'": {
            "'type'": "'google'",
            "'id'": "'#{@config[:ad_bottom_id]}'"
          }
        }
      }
      begin
        Net::SSH.start(@host, @user, password: @password) do |ssh|
          ssh.exec! "cd autobuild/; > configs/#{@config[:name]}.js; echo '#{site_config.strip}' >> configs/#{@config[:name]}.js"
        end
      rescue => error
        raise error
      end
    end

    def generate_static
      begin
        Net::SSH.start(@host, @user, password: @password) do |ssh|
          ssh.exec! "cd autobuild/; npm install"
          ssh.exec! "cd autobuild/; WEBSITE_NAME=#{@config[:name]} NODE_ENV=production npm run generate"
          ssh.exec! "cd autobuild/; rm -rf ./production"
          ssh.exec! "cd autobuild/; mkdir production"
          ssh.exec! "cd autobuild/; cp -a ./dist/. ./production/"
        end
      rescue => error
        raise error
      end
    end

    def update_nginx_sites(sites)
      sites_str = "'#{sites}'"

      result = ''
      Net::SSH.start(@host, @user, password: @password) do |ssh|
        channel = ssh.open_channel do |channel, success|
          channel.on_data do |channel, data|
            if data =~ /^\[sudo\] password for /
              channel.send_data "#{@password}\n"
            else
              result += data.to_s
            end
          end
          channel.request_pty
          channel.exec("sudo chmod 777 /etc/nginx/sites-available/default; sudo > /etc/nginx/sites-available/default; sudo echo #{sites_str} >> /etc/nginx/sites-available/default")
          channel.wait
        end
        channel.wait
      end
    end

    def set_beforessl_nginx_site
      acme_challenge_server = %Q{server {
        listen 0.0.0.0:80;
        server_name #{@config[:name]} www.#{@config[:name]};

        root /home/sammy/autobuild/production;
        index index.html;

        rewrite ^(/.*)\\.html(\\?.*)?$ $1$2 permanent;
        rewrite ^/(.*)/$ /$1 permanent;

        location / {
          try_files $uri/index.html $uri.html $uri/ $uri =404;
        }

        location ~ ^/(.well-known/acme-challenge/.*)$ {
          proxy_pass http://127.0.0.1:9999/$1;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header Host $http_host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
      }}
      update_nginx_sites(acme_challenge_server)
    end

    def set_afterssl_nginx_site
      ssl_config = %Q{server {
        listen 443 http2 default_server;
        listen [::]:443 http2 default_server;

        root /home/sammy/autobuild/production;

        index index.html;

        rewrite ^(/.*)\\.html(\\?.*)?$ $1$2 permanent;
        rewrite ^/(.*)/$ /$1 permanent;

        error_page 404 /404.html;
        error_page 500 502 503 504 /500.html;

        server_name #{@config[:name]} www.#{@config[:name]};

        location / {
          try_files $uri/index.html $uri.html $uri/ $uri =404;
        }

        ssl on;
        ssl_certificate /etc/letsencrypt/live/#{@config[:name]}/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/#{@config[:name]}/privkey.pem;

         gzip on;
         gzip_types application/javascript image/* text/css;
         gunzip on;
      }

      server {
        listen 0.0.0.0:80;
        server_name #{@config[:name]} www.#{@config[:name]};
        rewrite ^ https://$host$request_uri? permanent;
      }}
      update_nginx_sites(ssl_config)
    end

    def restart_nginx
      result = ''
      Net::SSH.start(@host, @user, password: @password) do |ssh|
        channel = ssh.open_channel do |channel, success|
          channel.on_data do |channel, data|
            if data =~ /^\[sudo\] password for /
              channel.send_data "#{@password}\n"
            elsif data =~ /Job for nginx.service failed/
              raise 'Restart nginx failed'
            else
              result += data.to_s
            end
          end
          channel.request_pty
          channel.exec("sudo service nginx restart")
          channel.wait
        end
        channel.wait
      end
    end
  end
end

