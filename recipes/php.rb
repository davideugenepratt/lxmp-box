#
# Cookbook:: lxmpbox
# Recipe:: php
#
# Copyright:: 2018, The Authors, All Rights Reserved.

phpversion = node.read('lxmpbox', 'php', 'version') ? node['lxmpbox']['php']['version'] : '7.2.5'
pearpackages = node.read('lxmpbox', 'php', 'pear_packages') ? node['lxmpbox']['php']['pear_packages'] : []
shasum = node['platform'] == 'ubuntu' || node['platform'] == 'debian' ? 'shasum -a 256' : 'sha256sum'

if node['platform'] == 'ubuntu' || node['platform'] == 'debian'
  package 'Install libxml2-dev' do
    package_name 'libxml2-dev'
  end
end

node.default['php']['version'] = phpversion

package 'curl' do
  action :install
end

node.override['php']['version'] = phpversion
Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
command = "echo -n `curl -L -s http://us1.php.net/get/php-#{phpversion}.tar.gz/from/this/mirror | #{shasum}` | tr -cd '[[:alnum:]]'"
command_out = shell_out(command)
node.override['php']['checksum'] = command_out.stdout

include_recipe 'php::source'

pearpackages.each_with_index do |req, _i|
  php_pear req do
    action :install
  end
end

package 'Install Zip' do
  package_name 'zip'
end
