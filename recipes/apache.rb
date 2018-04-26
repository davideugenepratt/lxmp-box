#
# Cookbook:: lxmpbox
# Recipe:: apache
#
# Copyright:: 2018, David Eugene Pratt, All Rights Reserved.

if node['platform'] == 'redhat' || node['platform'] == 'centos'

  package 'httpd' do
    action :install
  end

  service 'httpd' do
    action [:enable, :start]
  end

else

  package 'apache2' do
    action :install
  end

  service 'apache2' do
    action [:enable, :start]
  end

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
