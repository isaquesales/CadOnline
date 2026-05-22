class User < ApplicationRecord
  has_secure_password

  has_many :documents, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_documents, through: :favorites, source: :document
  has_many :privacy_requests, dependent: :destroy

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true, length: { maximum: 120 }
  validates :accepted_terms, inclusion: { in: [ true ] }
  validates :password, length: { minimum: 10 },
            format: {
              with: /(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*/,
              message: "deve conter letra minúscula, maiúscula e número"
            }, if: :password_present?

  before_validation :normalize_email

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def password_present?
    password.present?
  end
end
