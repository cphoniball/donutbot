require 'pathname'

class FileSystem
  def self.app_dir
    Pathname.new(__dir__).parent
  end

  def self.storage_dir
    app_dir.join("storage")
  end

  def self.storage_path(*child_path)
    storage_dir.join(*child_path)
  end
end
