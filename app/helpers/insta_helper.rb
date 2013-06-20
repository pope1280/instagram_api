helpers do

  def photos?
    
    if @client && @client.user_recent_media && @client.user.username == @user.username
      :_recent_photos
    else
      :_no_photos
    end
  end

  def get_popular_images(media_items)
    images = []
    media_items.each do |item|
      images << item.images.thumbnail.url
    end
    images
  end


  
end