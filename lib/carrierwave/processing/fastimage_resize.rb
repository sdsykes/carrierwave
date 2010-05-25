# encoding: utf-8

require "fastimage_resize"

module CarrierWave
  module FastImageResize
    extend ActiveSupport::Concern

    module ClassMethods
      def resize_to_limit(width, height)
        process :resize_to_limit => [width, height]
      end

      def resize_to_fit(width, height)
        process :resize_to_fit => [width, height]
      end
    end

    ##
    # Resize the image to fit within the specified dimensions while retaining
    # the original aspect ratio. The image may be shorter or narrower than
    # specified in the smaller dimension but will not be larger than the
    # specified values.
    #
    #
    # === Parameters
    #
    # [width (Integer)] the width to scale the image to
    # [height (Integer)] the height to scale the image to
    #
    def resize_to_fit(new_width, new_height)
      width, height = FastImage.size(self.current_path)
      width_ratio = new_width.to_f / width.to_f
      height_when_width_used = height * width_ratio
      if height_when_width_used <= new_height
        new_height = height_when_width_used
      else
        height_ratio = new_height.to_f / height.to_f
        new_width = width * height_ratio
      end
      FastImage.resize(self.current_path, self.current_path, new_width, new_height)
    end
    
    ##
    # Resize the image to fit within the specified dimensions while retaining
    # the original aspect ratio. Will only resize the image if it is larger than the
    # specified dimensions. The resulting image may be shorter or narrower than specified
    # in the smaller dimension but will not be larger than the specified values.
    #
    # === Parameters
    #
    # [width (Integer)] the width to scale the image to
    # [height (Integer)] the height to scale the image to
    #
    def resize_to_limit(new_width, new_height)
      width, height = FastImage.size(self.current_path)
      if width > new_width || height > new_height
        resize_to_fit(new_width, new_height)
      end
    end

  end # FastImageResize
end # CarrierWave
