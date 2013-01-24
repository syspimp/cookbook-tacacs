[![Build Status](https://travis-ci.org/alop/cookbook-tacacs.png?branch=master)](https://travis-ci.org/alop/cookbook-tacacs)
tacacs
======

Installs/Configures `tacacs`

REQUIREMENTS
============

ATTRIBUTES
==========

* default["tacacs"]["config"] - Path to configuration file for tacacs.
* default["tacacs"]["init"] - Path to tacacs init.d file.
* default["tacacs"]["default"] - Path to tacacs default file.
* default["tacacs"]["log_dir"] - Directory to store tacacs related log.
* default["tacacs"]["acct_log_path"] - Path to tacacs accounting log fi.le
* default["tacacs"]["interface"] - Interface to bind `tac_plus` process.

Optional:
* default['tacacs']['tac_key'] - key to use for tacacs client/server.

TEMPLATES
=========

* tac_plus_conf.erb
* tacacs.erb

USAGE
=====

```json
"run_list": [
    "recipe[tacacs]"
]
```

default
-------

Installs/Configures `tacacs`


TODO: Document the JSON needed to be added to each users data bag
for the search.

Admin:

```json
```

Viewer:

```json
```

Testing
=====

This cookbook is using [ChefSpec](https://github.com/acrmp/chefspec) for testing.

    $ cd $repo
    $ bundle
    $ librarian-chef install
    $ ln -s ../ cookbooks/tacacs
    $ rspec cookbooks/tacacs

License and Author
==================

Author:: Abel Lopez (<alop@att.com>)
Author:: Chen Xu (<xc1643@att.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
