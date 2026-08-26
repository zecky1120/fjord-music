# frozen_string_literal: true

class DiscordMessage
  def call(event)
    @content = event.content
    {
      caption: caption,
      discord_message_id: event.message.id,
      discord_channel_id: event.channel.id,
      title: title,
      url: url,
      thumbnail: thumbnail,
      user_id: event.message.author.id
    }
  end

  private

  def caption
    @content.gsub(URI::DEFAULT_PARSER.make_regexp, '').strip.presence
  end

  def url
    URI::DEFAULT_PARSER.make_regexp.match(@content).to_s
  end

  def parse_url
    Addressable::URI.parse(url)
  end

  def youtube_id
    if movie?
      with_v
    elsif playlist?
      with_playlist
    else
      without_v
    end
  end

  def with_v
    parse_url.query_values['v']
  end

  def without_v
    parse_url.to_s.scan(/\w+/)[3]
  end

  def with_playlist
    parse_url.query_values['list']
  end

  def youtube
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = Rails.application.credentials.youtube[:api_key]
    service
  end

  def title
    if playlist?
      youtube_list_playlists_info.items.first.snippet.title
    else
      youtube_list_videos_info.items.first.snippet.title
    end
  end

  def thumbnail
    playlist? ? nil : youtube_list_videos_info.items.first.snippet.thumbnails.medium.url
  end

  def playlist?
    url.include?('playlist?list=')
  end

  def movie?
    url.include?('watch?v=')
  end

  def youtube_list_videos_info
    youtube.list_videos('snippet', id: youtube_id)
  end

  def youtube_list_playlists_info
    youtube.list_playlists('snippet,contentDetails', id: youtube_id)
  end
end
