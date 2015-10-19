module ApplicationHelper
  # Return the full title on a per-page basic
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def redirect_to_back
  	redirect_to request.referrer || root_url
  end  
end
