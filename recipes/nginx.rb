#
# Cookbook:: lxmpbox
# Recipe:: nginx
#
# Copyright:: 2018, The Authors, All Rights Reserved.

if node['platform'] == 'redhat' || node['platform'] == 'centos'
  include_recipe 'yum'
  package 'epel-release' do
    action :install
  end
else
  include_recipe 'apt'
end

package 'nginx' do
  action :install
end

service 'nginx' do
  action [:enable, :start]
end

include_recipe 'firewall'

firewall 'ufw'

firewall_rule 'http' do
  port 80
end

firewall_rule 'https' do
  port 443
end

firewall_rule 'ssh' do
  port 22
end
