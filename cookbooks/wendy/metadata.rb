name             'wendy'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures wendy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          'git', '~> 4.3'
depends          'apt'
depends          'firewall'
depends          'desktop'
depends          'apache2'
