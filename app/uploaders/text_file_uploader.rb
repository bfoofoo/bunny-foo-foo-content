class TextFileUploader < CommonUploader
  def extension_whitelist
    %w(txt pdf doc docx)
  end
end 