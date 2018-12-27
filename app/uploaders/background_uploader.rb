class BackgroundUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick
    storage :file

    def extension_whitelist
        %w(jpeg jpg)
    end
  
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end 