name             "tacacs"
maintainer       "AT&T Services, Inc."
maintainer_email "xc1643@att.com"
license          "Apache 2.0"
description      "Installs/Configures tacacs"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.3"

recipe           "tacacs", "Installs/Configures tacacs"

%w{ ubuntu }.each do |os|
  supports os
end
