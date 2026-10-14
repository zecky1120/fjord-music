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

  def chenged_avatar_url(uid, avatar)
    if avatar.nil?
      Discordrb::API::User.default_avatar(discrim = 0)
    else
      Discordrb::API::User.avatar_url(uid, avatar)
    end
  end
end
