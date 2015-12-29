maintainer       'Gabor Szelcsanyi'
maintainer_email 'szelcsanyi.gabor@gmail.com'
license          'MIT'
description      'Installs/Configures redis, multi instace support'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name             'L7-redis'
version          '1.0.5'
source_url       'https://github.com/szelcsanyi/chef-redis'
issues_url       'https://github.com/szelcsanyi/chef-redis/issues'

supports 'ubuntu', '>= 12.04'
supports 'debian', '>= 7.0'

depends 'cron'
