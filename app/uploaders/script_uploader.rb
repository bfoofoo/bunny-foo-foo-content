class ScriptUploader < CommonUploader
  def extension_whitelist
    %w(js)
  end
end