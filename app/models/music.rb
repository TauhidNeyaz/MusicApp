class Music < ApplicationRecord
  belongs_to :user
  has_many :listening_histories, dependent: :destroy
  has_many :listeners, through: :listening_histories, source: :user

end
