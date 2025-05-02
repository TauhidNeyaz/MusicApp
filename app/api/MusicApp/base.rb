module MusicApp
    class Base < Grape::API
        mount MusicApp::V1::Auth
        mount MusicApp::V1::MusicRoute
        mount MusicApp::V1::Edit
        mount MusicApp::V1::SubscriptionRoute
        mount MusicApp::V1::PlayMusic
        mount MusicApp::V1::HistoryRoute
        mount MusicApp::V1::MostPlayedMusicRoute
        mount MusicApp::V1::SearchMusicRoute
        mount MusicApp::V1::InfoRoute
    end
end