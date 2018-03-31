class Team < ApplicationRecord

  belongs_to :store, class_name: 'User'
  belongs_to :courier, class_name: 'User'

  validates :courier_id, uniqueness: { scope: :store_id }
end
