#
# Cookbook:: lxmpbox
# Recipe:: php
#
# Copyright:: 2018, The Authors, All Rights Reserved.

phpversion = node.read('lxmpbox', 'php', 'version') ? node['lxmpbox']['php']['version'] : false
extensions = node.read('lxmpbox', 'php', 'extensions') ? node['lxmpbox']['php']['extensions'] : []
shasum = node['platform'] == 'ubuntu' || node['platform'] == 'debian' ? 'shasum -a 256' : 'sha256sum'

if node["platform"] == 'redhat' || node["platform"] == 'centos'
  package 'Install EPEL' do
    package_name 'epel-release'
  end
end

if node['platform'] == 'ubuntu' || node['platform'] == 'debian'
  package 'Install libxml2-dev' do
    package_name 'libxml2-dev'
  end
end

# install from source if specific php version is installed
if phpversion

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

=begin
  if node['platform'] == 'redhat' || node['platform'] == 'centos'
    bash 'update pecl' do
      code <<-EOH
        pecl channel-update pecl.php.net
      EOH
    end
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
      else
        code <<-EOH
          printf "\n" | pecl install #{req}
          # echo "extension=#{req}.so" >> #{node['php']['conf_dir']}/php.ini
        EOH
      end
    end
  end
=end
else
  include_recipe 'php::default'

=begin

  Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
  command = 'php -r "echo phpversion();"'
  command_out = shell_out(command)

  extensions.each_with_index do |req, _i|

      if node["platform"] == 'redhat' || node["platform"] == 'centos'

        package 'Install php-' + req do

          package_name 'php-' + req

        end

      end

      if node["platform"] == 'ubuntu' || node["platform"] == 'debian'

        if command_out.stdout.start_with? '7'

          package 'Install php7.0-' + req do

            package_name 'php7.0-' + req

          end

        else

          package 'Install php-' + req do

            package_name 'php-' + req

          end

        end

      end

  end

=end

end
