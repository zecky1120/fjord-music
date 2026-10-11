# frozen_string_literal: true

class DiscordBot
  def initialize
    @bot = Discordrb::Bot.new(
      client_id: Rails.application.credentials.discord[:client_id],
      token: Rails.application.credentials.discord[:token]
    )
  end

  def run
    @bot.message do |event|
      discord_message = DiscordMessage.new.call(event)
      Video.create_video_info(discord_message)
    end
    @bot.run
  end
end
