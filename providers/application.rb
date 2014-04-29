include Opscode::OpenSSL::Password

action :create do

  directory base_dir do
    owner new_resource.owner
    group new_resource.group
    mode '0755'
    recursive true
  end

  directory "#{base_dir}/shared" do
    owner new_resource.owner
    group new_resource.group
    mode '0755'
  end

  directory "#{base_dir}/shared/log" do
    owner new_resource.owner
    group new_resource.group
    mode '0750'
  end

  create_config_dir

  setup_database if new_resource.create_database
  database_config if new_resource.create_database
  setup_secrets if new_resource.secrets_data

end

def base_dir
  "#{node.rails_track.app_root}/#{new_resource.app_name}"
end

def config_dir
  "#{base_dir}/shared/config"
end

def create_config_dir
  directory config_dir do
    owner new_resource.owner
    group new_resource.group
    mode '0755'
  end
end

def database_config
  template "#{config_dir}/database.yml" do
    owner new_resource.owner
    group new_resource.group
    mode '0640'
    cookbook 'rails_track'
    source 'database.yml.erb'
    variables(
      :environment => new_resource.rails_env,
      :app_name => new_resource.app_name,
      :password => node['rails_track']['database_passwords'][new_resource.app_name]
    )
  end

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

def setup_secrets
  secrets_bag_name, secrets_bag_item = if(new_resource.secrets_data.is_a?(Array))
                                         new_resource.secrets_data
                                       else
                                         [new_resource.secrets_data, 'secrets']
                                       end
  secrets_from_bag = Chef::EncryptedDataBagItem.load(secrets_bag_name, secrets_bag_item)


  file "#{config_dir}/secrets.yml" do
    content secrets_from_bag.to_yaml
    owner new_resource.owner
    group new_resource.group
    mode '0640'
  end
end
