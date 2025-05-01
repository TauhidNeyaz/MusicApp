class NotifySubscribersJob < ApplicationJob
  queue_as :default

  def perform(music_id)
    music = Music.find_by(id: music_id)
    return unless music

    artist_id = music.user_id
    subscribers = User.where(role: 'listner')

    subscribers.each do |subscriber|
      subscription = Subscription.find_by(artist_id: artist_id, listener_id: subscriber.id)
      next unless subscription

      MusicMailer.new_music_email(subscriber, music).deliver_now
    end
  end
end
