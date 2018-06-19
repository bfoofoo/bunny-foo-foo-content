module EditableHelper

  # def editable(key, text = nil, options= {}, &block)
  #   content = StaticText.find_text(key) || text || capture(&block)
  #   return content.html_safe if current_admin_user.nil? || options[:nowrap]
  #   ["<span class=\"editable editable-text\">",
  #    "<a href='#' data-editable='#{key}' class='edit-link'>",
  #    "<img src='#{image_path 'edit-icon.svg'}'' alt='' />",
  #    '</a>',
  #    '<span class="editable-content">',
  #    content,
  #    '</span></span>'
  #   ].join.html_safe
  # end


  # def editable_link(key, text = nil, options= {}, &block)
  #   content = StaticText.find_text(key) || text || capture(&block)
  #   return content.html_safe if current_admin_user.nil? || options[:nowrap]
  #   ["<div href='#' data-editable='#{key}' class='edit-link edit-link-left'>",
  #     '<i class="fa fa-edit"></i> Edit',
  #     "</div>",
  #     "<span class=\"editable editable-text\">",
  #    content,
  #    '</span>'
  #   ].join.html_safe
  # end

  # def editable_image_tag(key, options = {})
  #   source = Image.find_replacement(key) || key
  #   return image_tag(source, options) unless current_admin_user.present?
  #   image_tag(asset_path(source), options.merge('data-editable-image' => key))
  # end

  # def editable_image_path(key, options = {})
  #   source = Image.find_replacement(key) || key
  #   if source
  #     asset_path(source)
  #   elsif key =~ /slider_top/
  #     asset_path('home-header-bg.jpg')
  #   else
  #     asset_path(key)
  #   end
  # end

  # def editable_preview_video_tag(key, video_name, options = {})
  #   source = Image.find_replacement(key) || key
  #   return video_tag(["#{video_name}.webm", "#{video_name}.mp4", "#{video_name}.ogv"], id: "homepage-video",  :poster => source) unless current_admin_user.present?
  #   video_tag(["#{video_name}.webm", "#{video_name}.mp4", "#{video_name}.ogv"], id: "homepage-video", autobuffer: true, :poster => source, :"data-editable-image" => key)
  # end
end
