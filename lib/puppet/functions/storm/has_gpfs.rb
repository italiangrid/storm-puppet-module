Puppet::Functions.create_function(:'storm::has_gpfs') do
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
