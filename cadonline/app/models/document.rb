class Document < ApplicationRecord
  PAPER_STYLES = %w[ruled blank grid kitalua].freeze
  PAPER_TONES = %w[default ivory warm gray].freeze

  belongs_to :user
  has_many :favorites, dependent: :destroy

  validates :title, presence: true, length: { maximum: 160 }
  validates :paper_style, inclusion: { in: PAPER_STYLES }
  validates :paper_tone, inclusion: { in: PAPER_TONES }
end
