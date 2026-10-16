# frozen_string_literal: true

module UsersHelper
  def user_name(user)
    if user.name == user.nickname
      user.name
    else
      "#{user.name}(#{user.nickname})"
    end
  end
end
