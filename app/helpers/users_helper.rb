module UsersHelper
  def gravatar_for(user, options = { _size: 80, _class: "media-object thumbnail" })
    gravatar_id = Digest::MD5::hexdigest(user.email)
    _size = options[:size]
    _class = options[:class]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{_size}"
    image_tag(gravatar_url, alt: user.name, class: "img-rounded" )
  end
end
