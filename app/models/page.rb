# frozen_string_literal: true

class Page < ApplicationRecord
  validates :title, :slug, :content, presence: true
  validates :title, :slug, uniqueness: true
  validates :slug, format: { with: /\A[a-zA-Z0-9_-]+\z/ }

  def to_param
    slug
  end
end
