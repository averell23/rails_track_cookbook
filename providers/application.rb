action :create do

  base = "#{node.rails_track.app_root}/#{new_resource.app_name}"

  directory base do
    owner new_resource.owner
    recursive true
  end

  setup_database if new_resource.create_database

end

def setup_database
  connection_info =  {:host => "localhost", :username => 'root', :password => node.mysql.server_root_password }

  node.set_unless['rails_track']['database_passwords'][new_resource.app_name] = secure_password
  app_password = node['rails_track']['database_passwords'][new_resource.app_name]

  mysql_database new_resource.app_name do
    connection connection_info
    action :create
  end

  mysql_database_user new_resource.app_name do
    connection connection_info
    password app_password
    database_name new_resource.app_name
    host 'localhost'
    privileges [:all]
    action :grant
  end
end
