# @!puppet.type.param
# @summary StoRM accounts configuration
#
# Parameters
# ----------
# 
# StoRM needs a 'storm' Unix user, member of an 'edguser' group.
# This class allows the creation of storm and edguser users.
# The parameters are:
#
# * `edguser_uid`: the user id of `edguser` user;
# * `edguser_gid`: the group id of `edguser` group;
# * `edguser_home`: the home path of `edguser`;
# * `storm_uid`: the user id of `storm` user;
# * `storm_gid`: the group id of `storm` group;
# * `storm_home`: the home path of `storm`;
# * `storm_groups`: the list of `storm` user memberships;
#
# @example Example of usage
#    class { 'storm::users':
#      storm_uid => 991,
#      storm_gid => 991,
#      storm_groups => ['storm', 'edguser', 'test'],
#    }
#
# @param edguser_uid
#   The user id of `edguser` user.
#
# @param edguser_gid
#
# @param edguser_home
#
# @param storm_uid
#
# @param storm_gid
#
# @param storm_home
#
# @param storm_groups
#
class storm::users (

  Integer $edguser_uid = 995,
  Integer $edguser_gid = 995,
  String $edguser_home = '/var/local/edguser',

  Integer $storm_uid = 991,
  Integer $storm_gid = 991,
  String $storm_home = '/home/storm',
  Array[String] $storm_groups = ['storm','edguser'],

) {

  accounts::user { 'edguser':
    ensure     => 'present',
    uid        => $edguser_uid,
    gid        => $edguser_gid,
    group      => 'edguser',
    home       => $edguser_home,
    comment    => 'EDG user',
    membership => 'inclusive',
  }

  accounts::user { 'storm':
    ensure     => 'present',
    uid        => $storm_uid,
    gid        => $storm_gid,
    group      => 'storm',
    groups     => $storm_groups,
    home       => $storm_home,
    comment    => 'StoRM user',
    membership => 'inclusive',
    require    => [Accounts::User['edguser']],
  }

}
