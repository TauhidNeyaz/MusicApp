module MusicApp
    module V1
        class MostPlayedMusicRoute < Grape::API
            prefix 'api'
            version 'v1', using: :path
            format :json

            helpers MusicApp::AuthHelper
            namespace :mostPlayed do

                before do 
                    authenticate_user!
                end

                desc 'Get the most played music'
                
                get :most_played do
                    if current_user.role == 'artist'
                        all_music = Music.where(user_id: current_user.id)
                        most_played_music = all_music.where.not(stream_count: nil).order(stream_count: :desc).first
                        { message: 'Most played music retrieved successfully', most_played_music: most_played_music }
                    else 
                        error!({ error: 'Only artists can view their most played music' }, 403)
                    end 
                end 
            end
        end 
    end 
end