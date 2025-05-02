class NotifySubscribersJob < ApplicationJob
  queue_as :default

  def perform(music_id)
    Rails.logger.info "Starting NotifySubscribersJob for music_id #{music_id}"
    music = Music.find_by(id: music_id)
    return unless music

    artist_id = music.user_id
    Rails.logger.info "Found music: #{music.title} for artist: #{music.user.name}"

    subscriptions = Subscription.where(artist_id: artist_id)
    subscriptions.each do |subscription|
      subscriber = subscription.listener
      Rails.logger.info "Notifying subscriber: #{subscriber.email}"
      MusicMailer.new_music_email(subscriber, music).deliver_now
    end
  end
end