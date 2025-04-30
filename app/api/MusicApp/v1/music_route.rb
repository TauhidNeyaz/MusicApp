module MusicApp
  module V1
    class MusicRoute < Grape::API
      prefix 'api'
      version 'v1', using: :path
      format :json

      helpers MusicApp::AuthHelper # Include the helper for authentication

      namespace :music do
        before do
          authenticate_user! # Authenticate the user using the helper
        end

        desc 'Upload music (only for artists)'
        params do
          requires :title, type: String
          requires :description, type: String
          requires :mp3_url, type: String
        end

        # Endpoint to upload music
        post :upload do
          authorize_artist! # Ensure only artists can upload music

          music = Music.new(
            title: params[:title],
            description: params[:description],
            mp3_url: params[:mp3_url],
            user_id: current_user.id
          )

          if music.save
            { message: 'Music uploaded successfully', music: music }
          else
            error!({ error: music.errors.full_messages }, 422)
          end
        end

        desc 'Get all music uploaded by the current artist'

        # This endpoint retrieves all music uploaded by the current artist
        get :my_music do
          authorize_artist! # Ensure only artists can view their music

          music = Music.where(user_id: current_user.id)
          { artist: current_user.name, music: music }
        end

        desc 'Update music details (excluding mp3_url)'
        params do
          requires :music_id, type: Integer
          optional :title, type: String
          optional :description, type: String
        end

        # Endpoint to update music details
        put :update do
          authorize_artist! # Ensure only artists can update music

          music = Music.find_by(id: params[:music_id], user_id: current_user.id)
          error!({ error: 'Music not found or not owned by you' }, 404) unless music

          if music.update(declared(params, include_missing: false).except(:music_id))
            { message: 'Music updated successfully', music: music }
          else
            error!({ error: music.errors.full_messages }, 422)
          end
        end

        desc 'Delete a music item'
        params do
          requires :music_id, type: Integer
        end

        # Endpoint to delete a music item
        delete :delete do
          authorize_artist! # Ensure only artists can delete music

          music = Music.find_by(id: params[:music_id], user_id: current_user.id)
          error!({ error: 'Music not found or not owned by you' }, 404) unless music

          if music.destroy
            { message: 'Music deleted successfully' }
          else
            error!({ error: 'Failed to delete music' }, 422)
          end
        end
      end
    end
  end
end