module MusicApp
    class Base < Grape::API
        mount MusicApp::V1::Auth
        mount MusicApp::V1::MusicRoute
    end
end