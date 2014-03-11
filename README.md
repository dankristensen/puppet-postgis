PostGIS Puppet module
=====================

Supported Environments:
-----

PostgreSQL 9.1+
PostGIS 2.1+
Ubuntu 12.04


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
    $postgis_version => 2.1
}

```

This will install the postgresql-9.3-postgis-2.1 package, create a `template\_postgis` template
database with geometry_columns and geometry_columns tables and grant some
privileges to PUBLIC role.

This module is originally by [Camptocamp](http://www.camptocamp.com/) and modified to
work with more modern versions of bioth 

## License

Copyright (c) 2013 <mailto:christian@propertybase.com> All rights reserved.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
