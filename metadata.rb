name 'lxmpbox'
maintainer 'David Eugene Pratt'
maintainer_email 'david@davideugenepratt.com'
license 'All Rights Reserved'
description 'Installs/Configures lxmpbox'
long_description 'Installs/Configures lxmpbox'
version '0.0.1'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'ubuntu'

issues_url 'https://github.com/davideugenepratt/lxmpbox/issues'
source_url 'https://github.com/davideugenepratt/lxmpbox'

depends 'apt'
depends 'yum'
depends 'firewall'