#
# Cookbook:: lxmpbox
# Recipe:: mysql
#
# Copyright:: 2018, The Authors, All Rights Reserved.

mysqlpassword = node.read('lxmpbox', 'mysql', 'password') ? node['lxmpbox']['mysql']['password'] : 'root'
mysqlip = node.read('lxmpbox', 'mysql', 'ip') ? node['lxmpbox']['mysql']['ip'] : '0.0.0.0'
mysqlport = node.read('lxmpbox', 'mysql', 'port') ? node['lxmpbox']['mysql']['port'] : '3306'
mysqlversion = node.read('lxmpbox', 'mysql', 'version') ? node['lxmpbox']['mysql']['version'] : '5.7'

mysql_service 'default' do
  version mysqlversion
  bind_address mysqlip
  port mysqlport
  data_dir '/data'
  initial_root_password 'root'
  action [:create, :start]
end

firewall_rule 'mysql' do
  port 3306
end
