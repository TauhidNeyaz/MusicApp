class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: :validate_password?

  has_many :musics, dependent: :destroy

  # Listener subscriptions
  has_many :subscriptions, foreign_key: :listener_id, dependent: :destroy
  has_many :subscribed_artists, through: :subscriptions, source: :artist

  # Artist subscribers
  has_many :reverse_subscriptions, class_name: 'Subscription', foreign_key: :artist_id, dependent: :destroy
  has_many :subscribers, through: :reverse_subscriptions, source: :listener

  has_many :listening_histories, dependent: :destroy
  has_many :recent_listened_musics, -> { where("listened_at >= ?", 7.days.ago) }, through: :listening_histories, source: :music


  def validate_password?
    new_record? || !password.nil?
  end
end
