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

There is/will be a puppet module that handle installation and configuration of Herald and prerequisites. Installing configuring and running with puppet is recommended. If you decided to take that approch check out: https://github.com/wavesoftware/puppet-herald

Installation, configuration and usage point seen below does not apply to installing with puppet!


Installation
-----

Herald typically should be installed on the same node or in management network of your puppet master. It will listen by default to localhost (this can be changed by `--bind` option). You should take care to properlly secure Herald if its publicly avialable (SSL, Authorization, Access List, Firewalls etc.). This could be easily done with Apache web server. Is approch is taken in puppet module (see above).

If you decided to install Herald by yourself, issue just:

```shell
sudo gem install puppet-herald
```

Configuration
-----

###PostgreSQL

PostgreSQL is recommended database backend for Herald. If you like to use PostgreSQL database to hold reports, you will need to configure it. By default, Herald will use a sqlite file that he tries to create in your home directory. Check out `puppet-herald --help` for description.

###Prerequisites for PostgreSQL

 * `libpq-dev` system package
 * `pg` gem package

On Ubuntu/Debian system install them with:

```shell
sudo apt-get install libpq-dev
sudo gem install pg
```

###Create a database

Just create a database for Herald (this is just a sample for PostgreSQL):

```sql
CREATE ROLE pherald LOGIN PASSWORD '<YOUR PASSWORD>'
  NOSUPERUSER INHERIT NOCREATEDB
  NOCREATEROLE NOREPLICATION;
CREATE DATABASE "pherald" WITH OWNER = pherald
  ENCODING = 'UTF8'
  TABLESPACE = pg_default;
```

Usage
-----

```shell
$ puppet-herald --help
```

Example usage of Herald with defaults:

```shell
puppet-herald # Navigate to http://localhost:11303/
```

Example usage of Herald with PostgreSQL and binding 127.0.1.1:

```shell
puppet-herald \
  --dbconn postgresql://pherald@master.cluster.vm:5432/pherald \
  --passfile /etc/pherald/passfile \
  --bind 127.0.1.1 # Navigate to http://127.0.1.1:11303/
```

Example usage of Herald with SQLite3 and binding to other host and port:

```shell
puppet-herald \
  --dbconn sqlite:///var/lib/puppet/reports/pherald.db \
  --bind master.cluster.vm \
  --port 8081 # Navigate to http://master.cluster.vm:8081/
```

Configuring puppet master
-------------------------

To send reports to Herald, you need to configure your puppet master to use custom report proccessor. This processor is also automatically configured if you choose to use a puppet module installation version. If not you must configure it by yourself.

First install a puppet-herald gem if you didn't do it already on puppet master:

```shell
sudo gem install puppet-herald
```

If you are running PE, run instead:

```shell
sudo /opt/puppet/bin/gem install puppet-herald
```

Then create a file in your puppet module directory (you can get modulepath with command: `puppet config print modulepath`). For example: `<puppet modules>/herald/lib/puppet/reports/herald.rb` with contents:

```ruby
require 'puppet'
require 'puppet-herald/client'

Puppet::Reports.register_report(:herald) do
  desc "Process reports via the Herald API."
  def process
    PuppetHerald::Client.new.process(self)
  end
end
```

If you need to post to other host or port use (defaults are: `localhost` and `11303`):

```ruby
require 'puppet'
require 'puppet-herald/client'

Puppet::Reports.register_report(:herald) do
  desc "Process reports via the Herald API."
  def process
    PuppetHerald::Client.new('master.secure.vm', 8082).process(self)
  end
end
```

Then edit your `puppet.conf` file and set `herald` as your report processor in section `main`:

```ini
[main]
   reports = puppetdb,herald
```

###Testing a ruby code

There are two types of tests distributed with the module. Unit tests and integration tests that uses sqlite as database backend in memory.

For unit testing, make sure you have:

 * rake
 * bundler

Install the necessary gems (gems will be downloaded to private .vendor directory):

```shell
bundle install --path .vendor
```

And then run the unit tests (for integration tests simply swap `unit` to `integration`):

```shell
bundle exec rake spec:unit
```

You can run single test with:

```shell
bundle exec rspec spec/unit/puppet-herald/version_spec.rb
```

You can also run all test with `test` target

###Testing a javascript code

To test javascript code, make sure you have:

 * nodejs

If so, issue this command to bootstart testing environment:

```shell
npm install
```

And then test Javascript code with:

```shell
bundle exec rake js:test
```

Check your code for quality with:

```shell
bundle exec rake rucocop
bundle exec rake inch
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
