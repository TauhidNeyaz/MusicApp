module MusicApp
    class Base < Grape::API
        mount MusicApp::V1::Auth
        mount MusicApp::V1::MusicRoute
        mount MusicApp::V1::Edit
    end
end