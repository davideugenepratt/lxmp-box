#
# Cookbook:: lxmpbox
# Recipe:: apache
#
# Copyright:: 2018, David Eugene Pratt, All Rights Reserved.

package "apache2" do
  action :install
end

service "apache2" do
  action [:enable, :start]
end
