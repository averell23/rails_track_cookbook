action :create do

  base = "#{node.rails_track.app_dir}/#{new_resource.app_name}"

  directory base do
    owner new_resource.owner
  end

end


