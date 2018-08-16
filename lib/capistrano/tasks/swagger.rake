namespace :swagger do
  desc "Clones swagger-ui from github to public/swagger"
  task :deploy do
    on roles(:app), in: :sequence do
      public_path = "~/bffadmin/shared/public"
      debug "public_path: #{public_path}"
      if test "[ ! -d #{public_path} ]"
        info "Creating shared public directory"
        execute 'mkdir', '-p', public_path
      end

      swagger_path = public_path + "/swagger"
      debug "swagger_path: #{swagger_path}"
      if test "[ \"$(ls -A #{swagger_path})\" ]"
        within swagger_path do
          info "Updating swagger-ui in #{swagger_path}"
          execute :git, :pull
        end
      else
        info "Cloning swagger-ui to #{swagger_path}"
        execute "git clone git@github.com:swagger-api/swagger-ui.git #{swagger_path}"
      end
    end
  end
  end
