# @!puppet.type.param
# @summary StoRM accounts configuration
#
# Parameters
# ----------
# 
# StoRM needs a 'storm' Unix user, member of an 'edguser' group.
# This class creates all the necessary users.
#
# @example Example of usage
#    class { 'storm::users':
#      groups => {
#        'infosys' => {
#          gid => '996',
#        },
#      },
#      users => {
#        'edguser' => {
#          'comment' => 'Edguser user',
#          'groups'  => [ edguser, infosys, storm, ],
#          'uid'     => '995',
#          'gid'     => '995',
#        },
#        'storm' => {
#          'comment' => 'StoRM user',
#          'groups'  => [ storm, edguser, ],
#          'uid'     => '991',
#          'gid'     => '991',
#        },
#      }
#    }
#
# @param groups
#
# @param users
#
class storm::users (

  Accounts::Group::Hash $groups = { },
  Accounts::User::Hash $users = {
    'edguser' => {
      'comment' => 'Edguser user',
      'groups'  => [ edguser, storm, ],
      'uid'     => '1101',
      'gid'     => '1101',
      'home'    => '/home/edguser',
    },
    'storm' => {
      'comment' => 'StoRM user',
      'groups'  => [ storm, edguser, ],
      'uid'     => '1100',
      'gid'     => '1100',
      'home'    => '/home/storm',
    },
  },

) {

  create_resources('group', $groups)
  create_resources('accounts::user', $users)
}
