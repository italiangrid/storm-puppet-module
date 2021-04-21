require 'spec_helper'

describe 'storm::has_gpfs' do

  it { is_expected.to run.with_params('gpfs', []).and_return(true) }

  it { is_expected.to run.with_params('posixfs', []).and_return(false) }

  it { is_expected.to run.with_params('posixfs', [
    {
      'name' => 'test.vo',
      'root_path' => '/storage/test.vo',
      'access_points' => ['/test.vo'],
      'vos' => ['test.vo', 'test.vo.2'],
      'storage_class' => 'T0D1',
      'online_size' => 4,
      'transfer_protocols' => ['file', 'gsiftp', 'webdav', 'xroot'],
      'fs_type' => 'gpfs',
    }
  ]).and_return(true) }

end