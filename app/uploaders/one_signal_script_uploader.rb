class OneSignalScriptUploader < CarrierWave::Uploader::Base
  def extension_whitelist
    %w(js)
  end
end
