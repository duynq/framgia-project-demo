class StaticPagesController < ApplicationController
  def home
  	if logged_in?
      @user = current_user
  		@entry = current_user.entries.build
  		@feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    else
      @user = User.new
  	end
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
