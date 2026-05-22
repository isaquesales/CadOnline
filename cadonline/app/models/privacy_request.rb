class PrivacyRequest < ApplicationRecord
  REQUEST_TYPES = %w[delete_my_data export_my_data].freeze

  belongs_to :user

  validates :request_type, inclusion: { in: REQUEST_TYPES }
  validates :status, inclusion: { in: %w[pending in_progress done rejected] }
end
