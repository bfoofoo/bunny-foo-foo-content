class SuppresionListUploader < CommonUploader
  def extension_whitelist
    %w(csv)
  end
end 