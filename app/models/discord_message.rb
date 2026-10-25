# frozen_string_literal: true

class DiscordMessage
  def initialize(event)
    @event = event
    @content = event.content
  end

  def call
    return unless YoutubeUrl.valid?(parse_url)

    {
      caption: caption,
      discord_message_id: @event.message.id,
      discord_channel_id: @event.channel.id,
      title: title,
      url: parse_url,
      thumbnail: thumbnail,
      user_id: @event.message.author.id
    }
  end

  def only_caption?
    caption.present? && parse_url.empty?
  end

  def except_youtube?
    parse_url.present? && !YoutubeUrl.valid?(parse_url)
  end

  private

  def caption
    parse_caption = @content.gsub(URI::DEFAULT_PARSER.make_regexp, '')
    parse_caption.gsub(/(^[[:space:]]+)|([[:space:]]+$)/, '')
  end

  def parse_url
    URI::DEFAULT_PARSER.make_regexp.match(@content).to_s
  end

  def uri
    Addressable::URI.parse(parse_url)
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
    uri.query_values['v']
  end

  def without_v
    uri.to_s.scan(/\w+/)[3]
  end

  def with_playlist
    uri.query_values['list']
  end

  def youtube
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = Rails.application.credentials.youtube[:api_key]
    service
  end

  def title
    item = if playlist?
            youtube_list_playlists_info.items.first
           else
            youtube_list_videos_info.items.first
           end
    return unless item&.snippet

    item.snippet.title
  end

  def thumbnail
    playlist? ? nil : youtube_list_videos_info.items.first.snippet.thumbnails.medium.url
  end

  def playlist?
    parse_url.include?('playlist?list=')
  end

  def movie?
    parse_url.include?('watch?v=')
  end

  def youtube_list_videos_info
    youtube.list_videos('snippet', id: youtube_id)
  end

  def youtube_list_playlists_info
    youtube.list_playlists('snippet,contentDetails', id: youtube_id)
  end
end
