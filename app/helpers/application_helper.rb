module ApplicationHelper
  def youtube_embed(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/] || youtube_url [/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]

      if youtube_url[/youtu\.be\/([^\?]*)/]
        youtube_id = $1
      else
        youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
        youtube_id = $5
      end

      %Q{<iframe title="YouTube video player"  src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe>}
    else
      if youtube_url[/https?:\/\/(?:www\.|player\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|video\/|)(\d+)(?:$|\/|\?)/]
        youtube_id = $3
      end

      %Q{<iframe src="https://player.vimeo.com/video/#{ youtube_id }" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>}
    end

  end
end
