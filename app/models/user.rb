class User < ApplicationRecord

  has_secure_password

  validates :first_name, :last_name, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email,
    presence: true,
    uniqueness: true,
    format: VALID_EMAIL_REGEX

  VALID_TYPES = %w(admin restaurant courier client guest)

  validate :valid_user_type

  geocoded_by :address

  after_validation :geocode

  def full_name
    "#{first_name} #{last_name}".titleize
  end

  private

  def valid_user_type
    VALID_TYPES.include? user_type
  end
end
