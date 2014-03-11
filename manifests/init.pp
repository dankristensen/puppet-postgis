# Class: postgis
#
# Install postgis using debian packages
#
# Parameters:
#   ['version']    - Version of the postgresql install to use
#   ['check_version'] - Whether to check the version specified using the
#                       `version` parameter. Set this to `false` if you
#                       are using your own backported version for example.
#
# Sample usage:
#   include postgis
#

class postgis (
  $version       = $::postgresql::globals::version,
  $check_version = true,
  $postgis_version = 2.1
) {

  #
  # check if the specified os, postgres and postgis versions are supported
  # by this script
  #

  if ($check_version) {
    case $::osfamily {
      'Debian' : {
        case $::lsbdistcodename {
          /^(precise|quantal)$/: {
            validate_re($version, '(9\.1|9\.2|9\.3)$', "version ${version} is not supported for ${::operatingsystem} ${::lsbdistcodename}!")
            validate_re($postgis_version, '2.1', "Only PostGIS 2.1 is currently supported!")
          }
          default: { fail "${::operatingsystem} ${::lsbdistcodename} is not yet supported!" }
        }
      }
      default: { fail "${::operatingsystem} is not yet supported!" }
    }
  }
  
  $script_path = $::osfamily ? {
    Debian => $version ? {
      /(9.1|9.2|9.3)/ => "/usr/share/postgresql/${version}/contrib/postgis-${postgis_version}",
    }
  }

  $packages = $::osfamily ? {
    Debian => ["postgresql-${version}-postgis-${postgis_version}"]
  }

  #
  # add postgis repository
  #
  exec {'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -':}
  ->
  exec {'echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >> /etc/apt/sources.list.d/postgresql.list':
    user => 'root',
    require => Class['postgresql::server']
  }
  ->
  exec {'apt-get update': }
  ->
  package { $packages:
    ensure => 'present',
  }
  #
  # create template database and install postgis in it
  #
  ->
  postgresql::server::database { 'template_postgis':
    istemplate => true,
  }
  ->
  exec { 'psql -q -d template_postgis -c "CREATE EXTENSION postgis;"':
    user    => 'postgres',
  }
  #
  # set appropriate access permissions
  #
  ->
  postgresql::server::table_grant { 'GRANT ALL ON geometry_columns TO public':
    privilege => 'ALL',
    table     => 'geometry_columns',
    db        => 'template_postgis',
    role      => 'public',
    notify    => postgresql_psql['vacuum postgis'],
  } 
  ->
  postgresql::server::table_grant { 'GRANT SELECT ON spatial_ref_sys TO public':
    privilege => 'SELECT',
    table     => 'spatial_ref_sys',
    db        => 'template_postgis',
    role      => 'public',
    notify    => postgresql_psql['vacuum postgis'],
  }
  
  #
  # VACUUM if necessary
  #

  postgresql_psql { 'vacuum postgis':
    command     => 'VACUUM FREEZE',
    db          => 'template_postgis',
    refreshonly => true,
  }
}
