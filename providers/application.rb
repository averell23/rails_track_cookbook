action :create do

  base = "#{node.rails_track.app_root}/#{new_resource.app_name}"

  directory base do
    owner new_resource.owner
    recursive true
  end

end


