class LearnsController < ApplicationController
  def pdf
    # reader = PDF::Reader.new("input.pdf")
    @image_page_paths = Array.new
    @file_name = params[:file_name]
    unless params[:file_name].nil?
      file_path = File.join(Rails.root, 'app', 'assets', 'files', params[:file_name])
      if File.file?(file_path)
        pages = params[:page].nil? ? [0, 1, 2] : [params[:page].to_i - 1]
        pages.each do |page|
          @image_page_paths << "#{File.basename(file_path, '.pdf')}_#{page}.jpg" 
          image_page_path = "public/images/#{@image_page_paths.last}"
          unless File.file?(image_page_path)
            page_img = MiniMagick::Image.open(file_path)
            page_img.format('jpg', page)
            page_img.write(image_page_path) { self.quality(100) }
          end
        end
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def haml

  end

  def i18n

  end


end
