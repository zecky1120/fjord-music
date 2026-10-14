# frozen_string_literal: true

class DiscordBot
  def initialize
    @bot = Discordrb::Bot.new(
      client_id: Rails.application.credentials.discord[:client_id],
      token: Rails.application.credentials.discord[:token],
      intents: [:server_messages, :server_members]
    )
  end

  def run
    member_update
    message
    @bot.run
  end

  private

  def not_logged_in(event)
    user = User.find_by(uid: event.message.author.id)
    url = 'http://localhost:3000'
    if user.nil?
      event.respond "初めまして！👋初めての投稿ですね！\nまずは[ログイン](#{url})からお願いします!"
    end
  end

  def message
    @bot.message do |event|
      not_logged_in(event)
      discord_message = DiscordMessage.new.call(event)
      Video.create_video_info(discord_message)
    end
  end

  def member_update
    @bot.member_update do |event|
      uid = event.user.id.to_s
      update_member = JSON.parse(Discordrb::API::User.resolve(@bot.token, uid))
      update_username = update_member['username']
      update_avatar = chenged_avatar_url(uid, update_member['avatar'])
      user = User.find_by(uid: uid)
      if user
        user.update!(name: update_username) if user.name != update_username
        user.update!(avatar_url: update_avatar) if user.avatar_url != update_avatar
      end
    end
  end

  def chenged_avatar_url(uid, avatar)
    if avatar.nil?
      Discordrb::API::User.default_avatar(discrim = 0)
    else
      Discordrb::API::User.avatar_url(uid, avatar)
    end
  end
end
