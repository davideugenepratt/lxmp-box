#
# Cookbook:: lxmpbox
# Recipe:: php
#
# Copyright:: 2018, The Authors, All Rights Reserved.

phpversion = node.read('lxmpbox', 'php', 'version') ? node['lxmpbox']['php']['version'] : '7.2.5'
extensions = node.read('lxmpbox', 'php', 'extensions') ? node['lxmpbox']['php']['extensions'] : []
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
command = "echo -n `curl -L -s #{node['php']['url']}/php-#{phpversion}.tar.gz/from/this/mirror | #{shasum}` | tr -cd '[[:alnum:]]'"
command_out = shell_out(command)
node.override['php']['checksum'] = command_out.stdout

include_recipe 'php::source'

phpdirectives = []

php_fpm_pool 'default' do
  action :install
end

extensions.each_with_index do |req, _i|
  phpdirectives.push("extension=#{req}.so")
  bash "pecl #{req}" do
    if node['platform'] == 'ubuntu' || node['platform'] == 'debian'
      code <<-EOH
        pecl install #{req}
        echo "extension=#{req}.so" >> #{node['php']['conf_dir']}/php.ini
        echo "extension=#{req}.so" >> #{node['php']['conf_dir']}/../fpm/php.ini
      EOH
    end
  end
end
