require 'spec_helper'

describe 'Storm::Backend::AclMode' do
  it { is_expected.to allow_value('AoT', 'JiT') }
  it { is_expected.not_to allow_value('aot', 'jit', 'other', '') }
end
