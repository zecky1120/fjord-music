# frozen_string_literal: true

module PagesHelper
  def static_pages
    Page.order(created_at: :desc)
  end
end
