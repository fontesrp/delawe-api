class User < ApplicationRecord

  has_secure_password

  before_validation :set_balance

  has_many :store_orders, class_name: 'Order', foreign_key: :store_id, dependent: :destroy
  has_many :courier_orders, class_name: 'Order', foreign_key: :courier_id, dependent: :destroy
  has_many :payments, class_name: 'Transaction', foreign_key: :creditor_id, dependent: :destroy
  has_many :earnings, class_name: 'Transaction', foreign_key: :debtor_id, dependent: :destroy
  has_many :courier_teams, class_name: 'Team', foreign_key: :store_id, dependent: :destroy
  has_many :couriers, through: :courier_teams
  has_one :store_team, class_name: 'Team', foreign_key: :courier_id, dependent: :destroy
  has_one :store, through: :store_team

  validates :first_name, :last_name, :address, :phone, presence: true
  validates :balance, numericality: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX

  TYPES = %w(admin store courier)

  validates :user_type, inclusion: { in: TYPES }

  validate :validate_business

  geocoded_by :address, if: :perform_geocoding?

  after_validation :geocode

  after_create :create_opening_balance

  private

  def validate_business
    if user_type == 'store' && !business_name.present?
      errors.add :business_name, 'must be present for stores'
    end
  end

  def set_balance
    self.balance ||= 0
  end

  def perform_geocoding?
    address.present? && address_changed?
  end

  def create_opening_balance
    Transaction.create creditor: self, debtor: User.first, amount: 0
  end
end
