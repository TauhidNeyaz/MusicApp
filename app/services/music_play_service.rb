
class MusicPlayService
    def initialize(user:, music:)
        @user = user
        @music = music
    end

    def call
        ActiveRecord::Base.transaction do
            log_listening_history
            increment_stream_count
        end
    end

    private

    def log_listening_history
        ListeningHistory.create!(
            user_id: @user.id,
            music_id: @music.id,
            listened_at: Time.current
        )
    end

    def increment_stream_count
        @music.increment!(:stream_count)
    end
end
