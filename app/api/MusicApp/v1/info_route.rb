module MusicApp
    module V1
        class InfoRoute < Grape::API
            prefix 'api'
            version 'v1', using: :path
            format :json

            helpers MusicApp::AuthHelper

            namespace :info do
                before do
                    authenticate_user!
                end

                get :all_songs do
                    songs = Music.all
                    if songs.empty?
                        {message: 'No songs available'}
                    else
                        {message: 'All songs', songs: songs}
                    end
                end

                get :all_artists do
                    artists = User.where(role: 'artist')
                    if artists.empty?
                        {message: 'No artists available'}
                    else
                        {message: 'All artists', artists: artists}
                    end
                end 
            end 
        end
    end
end