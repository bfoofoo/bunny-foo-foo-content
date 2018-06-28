require 'net/ssh'

module Deployer
  class BuilderService
    def initialize
    end

    def setup(config, host, user = 'sammy', password = "42Iknow42")
      puts 'setup'
      setup_host_data(host, user, password, config)
      clone_repo
      create_config_file
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
      create_config_file
      generate_static
    end

    private

    def setup_host_data(host, user, password, config)
      @host = host
      @user = user
      @password = password
      @config = config
    end

    def clone_repo
      Net::SSH.start(@host, @user, password: @password) do |ssh|
        ssh.exec! "git clone git@github.com:flywithmemsl/bunny-foo-foo-template.git site"
        ssh.exec! "cd site/; git checkout master"
        ssh.exec! "cd site/; git fetch --all"
        ssh.exec! "cd site/; git reset --hard origin/master"
      end
    end

    def pull_repo
      Net::SSH.start(@host, @user, password: @password) do |ssh|
        ssh.exec! "cd site/; git checkout master"
        ssh.exec! "cd site/; git fetch --all"
        ssh.exec! "cd site/; git reset --hard origin/master"
        ssh.exec! "cd site/; npm install"
      end
    end

    def setup_certbot
      puts 'setup_certbot'
      Net::SSH.start(@host, @user, password: @password) do |ssh|
        ssh.exec! "git clone https://github.com/certbot/certbot"
      end
    end

    def setup_bash
      puts 'setup_bash'
      bash_data = %Q{
        export LC_ALL='en_US.UTF-8'
        export LC_CTYPE='en_US.UTF-8'
      }

      bash_data_string = "'export LC_ALL=\"en_US.UTF-8\"'"
      bash_data_string_sec = "'export LC_CTYPE=\"en_US.UTF-8\"'"
      puts bash_data_string
      puts bash_data_string_sec
      Net::SSH.start(@host, @user, password: @password) do |ssh|
        ssh.exec! "echo #{bash_data_string} >> ~/.profile; echo #{bash_data_string_sec}  >> ~/.profile"
      end
    end

    def generate_ssl
      puts 'generate_ssl'
      result = ''
      Net::SSH.start(@host, @user, password: @password) do |ssh|
        channel = ssh.open_channel do |channel, success|
          channel.on_data do |channel, data|
            puts "@@@@ #{data} @@@@"
            if data =~ /^\[Do you want to continue\] /
              puts 'Y'
              channel.send_data "Y\n"
            elsif data =~ /^\[sudo\] password for /
              channel.send_data "#{@password}\n"
            else
              result += data.to_s
            end
          end
          channel.request_pty
          channel.exec "cd ~/certbot; ./certbot-auto --agree-tos --renew-by-default --standalone --standalone-supported-challenges http-01 --http-01-port 9999 --server https://acme-v01.api.letsencrypt.org/directory certonly -d #{@config[:name]} -d www.#{@config[:name]}"
          channel.wait
        end
        channel.wait
      end
    end

    def create_config_file
      site_config = %Q{
        module.exports = {
          'metaTitle': '#{@config[:name]}',
          'metaDescription': 'testdesc',
          'logoPath': '/logo.jpg',
          'email': 'admin@#{@config[:name]}',
        }
      }
      Net::SSH.start(@host, @user, password: @password) do |ssh|
        ssh.exec! "cd site/; echo '#{site_config.strip}' >> configs/#{@config[:name]}"
      end
    end

    def generate_static
      Net::SSH.start(@host, @user, password: @password) do |ssh|
        ssh.exec! "cd site/; npm install"
        # ssh.exec! "cd site/; WEBSITE_NAME=#{@config[:name]}.com NODE_ENV=production npm run generate"
        ssh.exec! "cd site/; WEBSITE_NAME=default NODE_ENV=production npm run generate"
        ssh.exec! "cd site/; rm -rf ./production"
        ssh.exec! "cd site/; mkdir production"
        ssh.exec! "cd site/; cp -a ./dist/. ./production/"
      end
    end

    def update_nginx_sites(sites)
      puts '@@@@ sites @@@@'
      puts sites
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
          # channel.exec("sudo touch /etc/nginx/sites-available/#{@config[:name]}; sudo chmod 777 /etc/nginx/sites-available/default; sudo > default; sudo chmod 777 /etc/nginx/sites-available/#{@config[:name]}; sudo echo #{sites_str} >> /etc/nginx/sites-available/#{@config[:name]}; sudo service nginx restart")
          channel.exec("sudo chmod 777 /etc/nginx/sites-available/default; sudo > /etc/nginx/sites-available/default; sudo echo #{sites_str} >> /etc/nginx/sites-available/default")
          puts '@@@ result @@@'
          puts result
          channel.wait
        end
        channel.wait
      end
    end

    def set_beforessl_nginx_site
      acme_challenge_server = %Q{server {
        listen 0.0.0.0:80;
        server_name #{@config[:name]} www.#{@config[:name]};

        root /home/sammy/site/production;
        index index.html;

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

        root /home/sammy/site/production;

        index index.html;

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
      puts 'restart_nginx'
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
          channel.exec("sudo service nginx restart")
          channel.wait
        end
        channel.wait
      end
    end

  end
end

