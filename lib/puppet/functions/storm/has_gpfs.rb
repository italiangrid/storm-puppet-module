# Function that compute whether at least one of the configured storage areas is deployed on GPFS.
#
Puppet::Functions.create_function(:'storm::has_gpfs') do
  # @param fs_type the default fs type value for all the storage areas
  # @param storage_areas the storage areas configuration.
  # @return [Boolean] Returns true if at least one of the configured storage area has GPFS as its file system.
  dispatch :check_gpfs do
    param 'Storm::Backend::FsType', :fs_type
    param 'Array[Storm::Backend::StorageArea]', :storage_areas
  end

  def check_gpfs(fs_type, storage_areas)
    if (fs_type == 'gpfs') then
      return true
    end
    storage_areas.select do |sa|
      return true if sa["fs_type"] == 'gpfs'
    end
    return false
  end
end
