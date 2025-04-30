module MusicApp
    module V1
        class HistoryRoute < Grape::API
            prefix 'api'
            version 'v1', using: :path
            format :json

            helpers MusicApp::AuthHelper

            namespace :history do

                before do
                    authenticate_user!
                end

                desc 'Get the play history of the current user'

                get :play_history do
                    if current_user.role == 'listener'
                        play_history = ListeningHistory.where(user_id: current_user.id)
                        { message: 'Play history retrieved successfully', play_history: play_history }
                    else
                        error!({ error: 'Only listeners can view play history' }, 403)
                    end
                end
            end
        end
    end
end