#
# Cookbook:: lxmpbox
# Recipe:: mysql
#
# Copyright:: 2018, The Authors, All Rights Reserved.

mysqlpassword = node.read('lxmpbox', 'mysql', 'password') ? node['lxmpbox']['mysql']['password'] : 'root'
mysqlip = node.read('lxmpbox', 'mysql', 'ip') ? node['lxmpbox']['mysql']['ip'] : '0.0.0.0'
mysqlport = node.read('lxmpbox', 'mysql', 'port') ? node['lxmpbox']['mysql']['port'] : '3306'
mysqlversion = node.read('lxmpbox', 'mysql', 'version') ? node['lxmpbox']['mysql']['version'] : '5.7'

include_recipe 'firewall'

if node['platform'] == 'redhat' || node['platform'] == 'centos'
  include_recipe 'yum-mysql-community::mysql' + mysqlversion.tr('.', '')
end

mysql_service 'default' do
  version mysqlversion
  bind_address mysqlip
  port mysqlport
  data_dir '/data'
  initial_root_password mysqlpassword
  action [:create]
end

if node['platform'] == 'redhat' || node['platform'] == 'centos'
  bash 'set mysql log context' do
    code <<-EOH
      chcon -R -u system_u -r object_r -t mysqld_db_t /var/log/mysql-default
      chcon -R -u system_u -r object_r -t mysqld_db_t /data
    EOH
  end
end

mysql_service 'default' do
  action :start
end

firewall_rule 'mysql' do
  port 3306
end

firewall_rule 'ssh' do
  port 22
end
