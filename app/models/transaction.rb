class Transaction < ApplicationRecord

  belongs_to :creditor, class_name: 'User'
  belongs_to :debtor, class_name: 'User'
  belongs_to :order, optional: true

  validates :amount, numericality: true

  after_create :update_users_amount

  private

  def update_users_amount

    User.transaction do

      creditor.lock!
      creditor.balance -= amount
      creditor.save!

      debtor.lock!
      debtor.balance += amount
      debtor.save!
    end
  end
end
