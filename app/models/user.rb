# frozen_string_literal: true

class User < ApplicationRecord
  has_many :videos, dependent: :destroy

  def self.find_or_create_from_discord_auth(discord_auth)
    is_owner = (new.owner_id.to_s == discord_auth.uid.to_s)

    find_or_create_by(uid: discord_auth.uid) do |user|
      user.admin      = is_owner
      user.avatar_url = discord_auth.info.image || default_avatar(discord_auth.uid)
      user.name       = discord_auth.info.name
      user.nickname   = discord_auth.extra.raw_info.global_name
      user.owner      = is_owner
      user.provider   = discord_auth.provider
      user.uid        = discord_auth.uid
    end
  end

  def self.default_avatar(uid)
    index = (uid.to_i >> 22) % 6
    "#{Discordrb::API.cdn_url}/embed/avatars/#{index}.png"
  end

  def owner_id
    guild_info = Discordrb::API::Server.resolve("Bot #{Rails.application.credentials.discord[:token]}", Rails.application.credentials.discord[:server_id])
    JSON.parse(guild_info.body)['owner_id']
  end
end
