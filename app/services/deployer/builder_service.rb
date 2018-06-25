require 'net/ssh'

module Deployer
  class BuilderService
    def initialize
    end

    def setup(config, host, user = 'sammy', password = "42Iknow42")
      # TODO add key to snapshot
      puts 'setup'
      Net::SSH.start(host, user, password: password) do |ssh|
        output = ssh.exec!("hostname")
        puts output
        puts 'test'
        ssh.exec! "git clone git@github.com:flywithmemsl/bunny-foo-foo-template.git site"
        ssh.exec! "cd site/; git checkout master"
        ssh.exec! "cd site/; git fetch --all"
        ssh.exec! "cd site/; git reset --hard origin/master"
        ssh.exec! "cd site/; npm install"
        # TODO add config
        ssh.exec! "cd site/;NODE_ENV=production npm run generate"
        ssh.exec! "cd site/; rm -rf ./production"
        ssh.exec! "cd site/; mkdir production"
        ssh.exec! "cd site/; cp -a ./dist/. ./production/'"
        # TODO nginx
        # TODO certbot
      end
    end

    def rebuild
      Net::SSH.start(host, user, password: password) do |ssh|
        ssh.exec! "cd site/; git checkout master"
        ssh.exec! "cd site/; git fetch --all"
        ssh.exec! "cd site/; git reset --hard origin/master"
        ssh.exec! "cd site/; npm install"
        # TODO add config
        ssh.exec! "cd site/; NODE_ENV=production npm run generate"
        ssh.exec! "cd site/; rm -rf ./production"
        ssh.exec! "cd site/; mkdir production"
        ssh.exec! "cd site/; cp -a ./dist/. ./production/'"
      end
    end
  end
end

