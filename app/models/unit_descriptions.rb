class UnitDescriptions
  include Virtus.model

  attribute :videos, Array, default: []
  attribute :images, Array, default: []
  attribute :text,   Array, default: []

  def self.from_descriptions(descriptions)
    return nil if descriptions.nil?
    return nil if descriptions[:multimedia_descriptions].nil?

    media = descriptions[:multimedia_descriptions][:multimedia_description]
    videos = []
    images = []
    text   = []

    media.each do |m|
      keys = m.keys
      if keys.include?(:image_items)
        images = clean_images(m[:image_items][:image_item])
      elsif keys.include?(:video_items)
        videos = clean_videos(m[:video_items][:video_item])
      elsif keys.include?(:text_items)
        text = clean_text(m[:text_items][:text_item])
      end
    end

    new(images: images, videos: videos, text: text)
  end

  def self.clean_images(images)
    images.map do |image|
      description = if image[:description].is_a?(Hash)
                      image[:description][:@caption]
                    elsif image[:description].is_a?(String)
                      image[:description]
                    end

      {
        formats:     clean_image_formats(image[:image_format]),
        description: description,
        category:    image[:@category] || 'None',
        default:     image[:@is_default] == 'true'
      }
    end
  end

  def self.clean_image_formats(formats)
    formats.map do |format|
      {
        url:      format[:url],
        width:    format[:@width],
        height:   format[:@height],
        category: format[:@dimension_category]
      }
    end
  end

  def self.clean_videos(videos)
    videos = [videos] unless videos.is_a?(Array)
    videos.map do |video|
      {
        formats: video[:video_format]
      }
    end
  end

  def self.clean_text(texts)
    texts.map do |text|
      {
        title:       text[:@title],
        description: text[:description]
      }
    end
  end
end
