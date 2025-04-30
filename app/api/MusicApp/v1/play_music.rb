module MusicApp
    module V1
        class PlayMusic < Grape::API
            prefix 'api'
            version 'v1', using: :path
            format :json

            helpers MusicApp::AuthHelper

            namespace :play do 

                before do
                    authenticate_user!
                end

                desc 'play a music track'

                params do
                    requires :music_id, type: Integer
                end

                post :play_music do
                    music = Music.find_by(id: params[:music_id])
                    error!({ error: 'Music not found' }, 404) unless music

                    if current_user.role == 'listener'
                        MusicPlayService.new(user: current_user, music: music).call
                        { message: 'Music is now playing', music: music }
                    else 
                        error!({ error: 'Only listeners can play music' }, 403)
                    end
                end
            end
        end
    end
end