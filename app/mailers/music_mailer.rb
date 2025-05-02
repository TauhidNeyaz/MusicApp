class MusicMailer < ApplicationMailer
    default from: 'neyaztauhid5555@gmail.com'
    def new_music_email(subscriber, music) 
        @subscriber = subscriber
        @music = music
        mail(
            to: @subscriber.email, 
            subject: "New music by #{music.user.name}: #{music.title}"
        )
    end 
end
