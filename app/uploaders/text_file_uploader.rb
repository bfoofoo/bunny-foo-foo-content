class TextFileUploader < CommonUploader
  def extension_whitelist
    %w(txt)
  end
end 