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
    member_leave
    member_update
    message
    @bot.run
  end

  private

  def not_logged_in(event)
    user = User.find_by(uid: event.message.author.id)
    url = 'http://127.0.0.1:3000'
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

  def member_leave
    @bot.member_leave do |event|
      user_id = event.user.id
      user = User.find_by(uid: user_id)
      user&.destroy
    end
  end

  def member_update
    @bot.member_update do |event|
      uid = event.user.id.to_s
      discord_user = JSON.parse(Discordrb::API::User.resolve(@bot.token, uid))
      username = discord_user['username']
      nickname = discord_user['global_name']
      avatar = chenged_avatar_url(uid, discord_user['avatar'])
      user = User.find_by(uid: uid)
      if user
        user.update!(name: username) if user.name != username
        user.update!(nickname: nickname) if user.nickname != nickname
        user.update!(avatar_url: avatar) if user.avatar_url != avatar
      end
    end
  end

  def chenged_avatar_url(uid, avatar)
    if avatar.nil?
      User.default_avatar(uid)
    else
      Discordrb::API::User.avatar_url(uid, avatar)
    end
  end
end
