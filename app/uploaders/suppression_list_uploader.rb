class SuppressionListUploader < CommonUploader
  def extension_whitelist
    %w(csv)
  end
end 
