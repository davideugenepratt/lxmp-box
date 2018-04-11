#
# Cookbook:: lxmpbox
# Recipe:: apache
#
# Copyright:: 2018, David Eugene Pratt, All Rights Reserved.

if node[:platform_family].include?("rhel")

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
