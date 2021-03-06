# Custom CDJ Aude ============================
#= Connexion Serveur ==============================================
server '178.170.55.154', user: "deploy", roles: [:web, :app, :db], primary: true
set :ssh_options, {forward_agent: true, port: 124}
set :user,            'deploy'
set :deploy_to,       "/home/#{fetch(:user)}/www/#{fetch(:application)}"
set :stage,           :staging
set :rails_env,       'staging'
set :branch,          "staging"

#= RVM ==============================================
set :rvm_ruby_version, '2.3.2@cdj_aude'

#= Puma ==============================================
set :puma_threads,    [4, 8]
set :puma_workers,    8  # grep -c processor /proc/cpuinfo
set :puma_env,        'staging'
set :puma_bind,       "unix://#{shared_path}/sockets/#{fetch(:application)}.sock"
set :puma_state,      "#{shared_path}/pids/puma.state"
set :puma_pid,        "#{shared_path}/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

set :db_name, 'cdj_aude_production'

# # Consul version ==========================

# set :deploy_to, deploysecret(:deploy_to)
# set :server_name, deploysecret(:server_name)
# set :db_server, deploysecret(:db_server)
# set :branch, ENV['branch'] || :master
# set :ssh_options, port: deploysecret(:ssh_port)
# set :stage, :staging
# set :rails_env, :staging

# server deploysecret(:server), user: deploysecret(:user), roles: %w(web app db importer cron)


