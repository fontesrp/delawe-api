class Order < ApplicationRecord

  belongs_to :store, class_name: 'User'
  belongs_to :courier, class_name: 'User', optional: true

  has_many :transactions, dependent: :destroy

  validates :address, :aasm_state, presence: true
  validates :value, numericality: { greater_than: 0 }
  validate :validate_store
  validate :validate_courier

  geocoded_by :address, if: :perform_geocoding?

  after_validation :geocode

  STATES = [:pending, :assigned, :on_transit, :delivered, :canceled]

  include AASM

  aasm whiny_transitions: false do

    state :pending, initial: true
    state :assigned
    state :on_transit
    state :delivered
    state :canceled

    event :assign do
      transitions from: :pending, to: :assigned, guard: :courier_present?, success: :charge_store
    end

    event :unassign do
      transitions from: :assigned, to: :pending, guard: :courier_missing?, success: :reimburse_store
    end

    event :reassign do
      transitions from: :assigned, to: :assigned, guard: :courier_id_changed?
    end

    event :pickup do
      transitions from: :assigned, to: :on_transit
    end

    event :deliver do
      transitions from: :on_transit, to: :delivered, success: :pay_courier
    end

    event :cancel do
      transitions from: [:pending, :assigned, :on_transit], to: :canceled, success: :cancel_order
    end
  end

  private

  def validate_store

    permitted_types = %w(admin store)

    unless permitted_types.include? store.user_type
      errors.add :store, "must be of types [#{permitted_types.join(', ')}]"
    end
  end

  def validate_courier
    if courier.present? && courier.user_type != 'courier'
      errors.add :courier, "must be of type courier"
    end
  end

  def perform_geocoding?
    address.present? && address_changed?
  end

  def courier_present?
    courier.present?
  end

  def courier_missing?
    !courier_present?
  end

  def charge_store
    Transaction.create order: self, creditor: store, debtor: User.first, amount: value
  end

  def pay_courier
    Transaction.create order: self, creditor: User.first, debtor: courier, amount: value
  end

  def reimburse_store
    Transaction.create order: self, creditor: User.first, debtor: store, amount: value
  end

  def cancel_order
    reimburse_store unless aasm.from_state == :pending
  end
end
