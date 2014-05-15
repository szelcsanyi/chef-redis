maintainer       "Gabor Szelcsanyi"
maintainer_email "szelcsanyi.gabor@gmail.com"
license          "MIT"
description      "Installs/Configures redis"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name             "redis"
version          "1.0.0"

%w{ ubuntu debian }.each do |os|
  supports os
end
