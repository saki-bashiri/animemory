set :user, 'animemory_stg'
set :password, ENV['STAGING_PASSWORD']
set :domain, 'bluejays.dreamhost.com'
set :project, 'animemory'
set :application, "animemory"
set :applicationdir, '/home/animemory_stg/'


set :checkout_dir, '/home/animemory_stg/checkout'
set :tar_dir, '/home/animemory_stg/'
set :upload_dir, '/home/animemory_stg/'
set :deploy_dir, '/home/animemory_stg/'
set :deploy_to, '/home/animemory_stg/'

set :own_user, 'animemory_stg'

set :rails_env, 'production'