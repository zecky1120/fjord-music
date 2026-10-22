# frozen_string_literal: true

module YoutubeUrl
  ALLOWED_HOSTS = %w[youtube.com www.youtube.com music.youtube.com youtu.be].freeze

  def self.valid?(url)
    return false unless url

    host = Addressable::URI.parse(url).host
    ALLOWED_HOSTS.include?(host)
  end
end
