class Subscription < ApplicationRecord
    belongs_to :listener, class_name: 'User'
    belongs_to :artist, class_name: 'User'
  
    validates :listener_id, uniqueness: { scope: :artist_id }
end
  