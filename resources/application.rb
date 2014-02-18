def initialize(*args)
  super
  @action = :create
end

actions :create

attribute :app_name, :kind_of => String, :name_attribute => true
attribute :owner, :kind_of => String, :default => 'root'
attribute :group, :kind_of => String, :default => 'root'
attribute :create_database, :kind_of => [TrueClass, FalseClass, String], :default => false
