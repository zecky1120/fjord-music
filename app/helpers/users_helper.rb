# frozen_string_literal: true

module UsersHelper
  def user_name(user)
    if user.name == user.nickname
      user.name
    else
      "#{user.name}(#{user.nickname})"
    end
  end

  def user_avatar(user, size: '60x60', class_name: 'inline')
    image_tag user.avatar_url, size:, class: class_name, alt: user_name(user)
  end
end
