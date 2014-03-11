PostGIS Puppet module
=====================

Supported Environments:
-----

PostgreSQL 9.1+
PostGIS 2.1+
Ubuntu 12.04

Use with https://github.com/puppetlabs/puppetlabs-postgresql

Usage
-----

```puppet
Exec {
  path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
}

class {'postgresql::globals':
  version => '9.3',
  manage_package_repo => true,
  encoding => 'UTF8'
} ->
class { 'postgresql::server': 
  ensure => 'present'
} 

class { 'postgis': 
  postgis_version => 2.1
}

```

This will install the postgresql-9.3-postgis-2.1 package, create a `template\_postgis` template
database with geometry_columns and geometry_columns tables and grant some
privileges to PUBLIC role.

This module is originally by [Camptocamp](http://www.camptocamp.com/) and modified to
work with more modern versions of both PostgreSQL and PostGIS.