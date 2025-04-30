module MusicApp
    module V1
      class SearchMusicRoute < Grape::API
        prefix 'api'
        version 'v1', using: :path
        format :json
  
        helpers MusicApp::AuthHelper
  
        namespace :music do
          before do
            authenticate_user!
          end
  
          desc 'Search music by song title or artist name'
          params do
            requires :query, type: String, desc: 'Search query'
          end
  
          get :search do
            query = params[:query].downcase
  
            # Search artist first
            artist = User.where("LOWER(name) ILIKE ?", "%#{query}%").first
            songs_by_artist = artist ? Music.where(user_id: artist.id) : []
  
            # Search by music title
            songs_by_title = Music.where("LOWER(title) ILIKE ?", "%#{query}%")
  
            results = (songs_by_artist + songs_by_title).uniq
  
            if results.empty?
              { message: "No music found for '#{params[:query]}'" }
            else
              { message: "Search results for '#{params[:query]}'", music: results }
            end
          end
        end
      end
    end
  end
  