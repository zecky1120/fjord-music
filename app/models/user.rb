# frozen_string_literal: true

class User < ApplicationRecord
  has_many :videos, dependent: :destroy

  def self.find_or_create_from_discord_auth(discord_auth)
    find_or_create_by(uid: discord_auth.uid) do |user|
      user.update(
        name: discord_auth.info.name,
        nickname: discord_auth.extra.raw_info.global_name,
        avatar_url: discord_auth.info.image || default_avatar(discord_auth.uid),
        uid: discord_auth.uid,
        provider: discord_auth.provider
      )
    end
  end

  def self.default_avatar(uid)
    index = (uid.to_i >> 22) % 6
    "#{Discordrb::API.cdn_url}/embed/avatars/#{index}.png"
  end
end
