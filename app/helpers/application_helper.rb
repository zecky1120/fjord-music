# frozen_string_literal: true

module ApplicationHelper
  def markdown(text) # rubocop:disable Metrics/MethodLength
    return '' if text.blank?

    options = {
      escape_html:       true,
      hard_wrap:         true,
      link_attributes: { rel: 'nofollow', target: '_blank' }
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true,
      no_intra_emphasis:  true,
      lax_spacing:        true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    html_content = markdown.render(text)

    sanitize(html_content, tags: %w[p br strong em a h1 h2 h3 h4 h5 ul ol li code pre],
                           attributes: %w[href target rel class])
  end
end
