maintainer       "AT&T Services, Inc."
maintainer_email "xc1643@att.com"
license          "All rights reserved"
description      "Installs/Configures tacacs"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"

recipe           "tacacs", "Installs/Configures tacacs"

%w{ ubuntu }.each do |os|
  supports os
end
