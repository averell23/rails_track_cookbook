def initialize(*args)
  super
  @action = :create
end

actions :create

attribute :app_name, :kind_of => String, :name_attribute => true
attribute :owner, :kind_of => String, :default => 'root'
attribute :group, :kind_of => String, :default => 'root'
attribute :rails_env, :kind_of => String, :default => 'production'
attribute :create_database, :kind_of => [TrueClass, FalseClass, String], :default => false
# The name of a databag for the secrets.yml contents. If an array is given, it is interpreted
# as data_bag_name, data_bag_item_name
# If a string is given, the data_bag_item name defaults to 'secrets'
#
# It is assumed that the data bag is encrypted
attribute :secrets_data, :kind_of => [String, Array], default => nil
