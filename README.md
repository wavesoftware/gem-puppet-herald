puppet-herald gem
========

##### Status Info
[![GitHub Issues](https://img.shields.io/github/issues/wavesoftware/gem-puppet-herald.svg)](https://github.com/wavesoftware/gem-puppet-herald/issues) [![Gem](http://img.shields.io/gem/v/puppet-herald.svg)](https://rubygems.org/gems/puppet-herald) [![GitHub Release](https://img.shields.io/github/release/wavesoftware/gem-puppet-herald.svg)](https://github.com/wavesoftware/gem-puppet-herald/releases) [![Apache 2.0 License](http://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://raw.githubusercontent.com/wavesoftware/gem-puppet-herald/develop/LICENSE)

##### Master (stable) branch
[![Build Status](https://img.shields.io/travis/wavesoftware/gem-puppet-herald/master.svg)](https://travis-ci.org/wavesoftware/gem-puppet-herald) [![Dependency Status](https://gemnasium.com/wavesoftware/gem-puppet-herald.svg)](https://gemnasium.com/wavesoftware/gem-puppet-herald) [![Coverage Status](https://img.shields.io/coveralls/wavesoftware/gem-puppet-herald/master.svg)](https://coveralls.io/r/wavesoftware/gem-puppet-herald?branch=master) [![Code Climate](https://codeclimate.com/github/wavesoftware/gem-puppet-herald/badges/gpa.svg?branch=master)](https://codeclimate.com/github/wavesoftware/gem-puppet-herald) [![Inline docs](http://inch-ci.org/github/wavesoftware/gem-puppet-herald.svg?branch=master)](http://inch-ci.org/github/wavesoftware/gem-puppet-herald)

##### Development branch
[![Build Status](https://img.shields.io/travis/wavesoftware/gem-puppet-herald/develop.svg)](https://travis-ci.org/wavesoftware/gem-puppet-herald) [![Dependency Status](https://gemnasium.com/wavesoftware/gem-puppet-herald.svg)](https://gemnasium.com/wavesoftware/gem-puppet-herald) [![Coverage Status](https://img.shields.io/coveralls/wavesoftware/gem-puppet-herald/develop.svg)](https://coveralls.io/r/wavesoftware/gem-puppet-herald?branch=develop) [![Code Climate](https://codeclimate.com/github/wavesoftware/gem-puppet-herald/badges/gpa.svg?branch=develop)](https://codeclimate.com/github/wavesoftware/gem-puppet-herald) [![Inline docs](http://inch-ci.org/github/wavesoftware/gem-puppet-herald.svg?branch=develop)](http://inch-ci.org/github/wavesoftware/gem-puppet-herald) 

Overview
--------

Herald is a puppet report processor. He provides a gateway for consuming puppet reports, a REST API and a simple Web app to display reports.

![A reports list](https://raw.githubusercontent.com/wavesoftware/gem-puppet-herald/gh-pages/images/reports.png)

![A logs of single report](https://raw.githubusercontent.com/wavesoftware/gem-puppet-herald/gh-pages/images/logs.png)

Puppet module
-----

There is/will be a puppet module that handle installation and configuration of Herald and prerequisites. Check that out: https://github.com/wavesoftware/puppet-herald

Prerequisites
-----

 * `libpq-dev`

On Ubuntu/Debian system install them with:

```shell
sudo apt-get install libpq-dev
```

Installation
-----

Install Herald and all dependencies from http://rubygems.org:
```shell
sudo gem install puppet-herald
```

Configuration
-----

If you like to use PostgreSQL database to hold reports, you will need to configure it. By default, Herald will use a sqlite file that he tries to create in your home directory. Check out `puppet-herald --help` for description.

###Create a database

Just create a database for Herald (this is just a sample):
```sql
CREATE ROLE pherald LOGIN PASSWORD '<YOUR PASSWORD>' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
CREATE DATABASE "pherald" WITH OWNER = pherald
  ENCODING = 'UTF8'
  TABLESPACE = pg_default;
```

Usage
-----

```shell
$ puppet-herald --help
```

Example of running a server with using sqlite and binding to other host and port:

```shell
puppet-herald --dbconn sqlite:///var/lib/puppet/reports/pherald.db --bind master.cluster.vm --port 8081
```

###Contributing

Contributions are welcome!

To contribute, follow the standard [git flow](http://danielkummer.github.io/git-flow-cheatsheet/) of:

1. Fork it
1. Create your feature branch (`git checkout -b feature/my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin feature/my-new-feature`)
1. Create new Pull Request

Even if you can't contribute code, if you have an idea for an improvement please open an [issue](https://github.com/wavesoftware/gem-puppet-herald/issues).
