bin/rake db:drop
bin/rake db:create
bin/rake db:migrate VERSION=20170513110025
psql cdj_development < doc/custom/extract_db_insert_190124.sql
bin/rake db:migrate
bin/rake db:custom_seed
bin/rake custom:finalize_db_import
