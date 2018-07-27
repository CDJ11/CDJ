# Custom CDJ Aude ============================

lock '~> 3.10.1'

set :application, "cdj_aude"
set :repo_url, "git@github.com:CDJ11/CDJ.git"

set :pty,             true
set :use_sudo,        false
set :deploy_via,      :remote_cache
# can be customized for use with https://github.com/capistrano-plugins/capistrano-faster-assets :
set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)

#= Callbacks ==============================================
after "bundler:install", :create_symbolic_links do
  on roles(:app) do
    execute "cp #{release_path}/config/database_#{fetch(:rails_env)}.yml #{release_path}/config/database.yml"
    execute "cp #{release_path}/config/secrets_#{fetch(:rails_env)}.yml #{release_path}/config/secrets.yml"
    execute "rm -rf #{release_path}/public/uploads"
    execute "ln -s #{shared_path}/public/uploads #{release_path}/public/uploads"
    execute "rm -rf #{release_path}/log"
    execute "ln -s #{shared_path}/log #{release_path}/log"
  end
end

#= Puma ==============================================
namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/sockets -p"
      execute "mkdir #{shared_path}/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Run seeds'
  task :seed do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:custom_seed"
        end
      end
    end
  end


  # En amont,
  # - avoir la bdd à importer sur le server :
  # - en se connectant avec le user mako : sudo service postgresql restart


  desc 'Import DB'
  task :import_db do
    on primary :db do
    # on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          # execute "sudo service postgresql restart"
          invoke 'delayed_job:stop'
          invoke 'puma:stop'
          execute :rake, "db:drop"
          execute :rake, "db:create"
          execute :rake, "db:migrate VERSION=20170513110025"
          execute "psql #{fetch(:db_name)} < doc/custom/extract_db_insert_180326.sql"
          execute :rake, "db:migrate"
          execute :rake, "db:seed"
          execute :rake, "db:custom_seed"
          execute :rake, "custom:finalize_db_import"
          # execute "./lib/custom/import_db.sh"
          invoke 'puma:start'
          invoke 'delayed_job:start'
        end
      end
    end
  end

  task :prepare_import_db do
    on primary :db do
    # on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          # execute "sudo service postgresql restart"
          # invoke 'delayed_job:stop'
          # invoke 'puma:stop'
          execute :rake, "db:drop"
          execute :rake, "db:create"
          execute :rake, "db:migrate VERSION=20170513110025"
          # execute "psql #{fetch(:db_name)} < doc/custom/extract_db_insert_180326.sql"
          # execute :rake, "db:migrate"
          # execute :rake, "db:seed"
          # execute :rake, "db:custom_seed"
          # execute :rake, "custom:finalize_db_import"
          # # execute "./lib/custom/import_db.sh"
          # invoke 'puma:start'
          # invoke 'delayed_job:start'
        end
      end
    end
  end

  task :finish_import_db do
    on primary :db do
    # on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          # execute "psql #{fetch(:db_name)} < doc/custom/extract_db_insert_180326.sql"
          execute :rake, "db:migrate"
          # execute :rake, "db:seed"
          execute :rake, "db:custom_seed"
          execute :rake, "custom:finalize_db_import"
          # execute "./lib/custom/import_db.sh"
          # invoke 'puma:start'
          # invoke 'delayed_job:start'
        end
      end
    end
  end


  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup

end

# # Consul version ==========================
# lock '~> 3.10.1'

# def deploysecret(key)
#   @deploy_secrets_yml ||= YAML.load_file('config/deploy-secrets.yml')[fetch(:stage).to_s]
#   @deploy_secrets_yml.fetch(key.to_s, 'undefined')
# end

# set :rails_env, fetch(:stage)
# set :rvm1_ruby_version, '2.3.2'

# set :application, 'cdj_aude'
# set :full_app_name, deploysecret(:full_app_name)

# set :server_name, deploysecret(:server_name)
# set :repo_url, 'https://github.com/CDJ11/CDJ.git'

# set :revision, `git rev-parse --short #{fetch(:branch)}`.strip

# set :log_level, :info
# set :pty, true
# set :use_sudo, false

# set :linked_files, %w{config/database.yml config/secrets.yml}
# set :linked_dirs, %w{log tmp public/system public/assets}

# set :keep_releases, 5

# # set :local_user, ENV['USER']
# set :local_user, 'deploy'

# set :delayed_job_workers, 2
# set :delayed_job_roles, :background

# set(:config_files, %w(
#   log_rotation
#   database.yml
#   secrets.yml
#   unicorn.rb
# ))

# set :whenever_roles, -> { :app }

# namespace :deploy do
#   # before :starting, 'rvm1:install:rvm'  # install/update RVM
#   # before :starting, 'rvm1:install:ruby' # install Ruby and create gemset
#   before :starting, 'install_bundler_gem' # install bundler gem

#   after :publishing, 'deploy:restart'
#   after :published, 'delayed_job:restart'
#   after :published, 'refresh_sitemap'

#   after :finishing, 'deploy:cleanup'
# end

# task :install_bundler_gem do
#   on roles(:app) do
#     execute "rvm use #{fetch(:rvm1_ruby_version)}; gem install bundler"
#   end
# end

task :refresh_sitemap do
  on roles(:app) do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, 'sitemap:refresh:no_ping'
      end
    end
  end
end
