set :rails_env, "production"

set :application, 'authorialx'
set :repo_url, 'https://github.com/sul-cidr/authorialx.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/opt/app/cidr/authorialx'

# Default value for :linked_files is []
set :linked_files, %w[config/secrets.yml config/database.yml]

# Default value for linked_dirs is []
set :linked_dirs, %w[log public/system tmp/pids tmp/cache tmp/sockets data]

# Default value for keep_releases is 5
set :keep_releases, 3

# Install devDependencies
set :npm_flags, '--silent --no-spin'

# Don't bundle development stuff in prod
set :bundle_without, %w[development]

