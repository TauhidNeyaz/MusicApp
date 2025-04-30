module MusicApp
    module V1
        class Edit < Grape:: API
            prefix 'api'
            version 'v1', using: :path
            format :json

            helpers MusicApp::AuthHelper # Include the helper for authentication
            namespace :edit do
                before do 
                    authenticate_user! # Authenticate the user using the helper
                end

                desc 'delete a user account'

                delete :delete_user do
                    begin
                        ActiveRecord::Base.transaction do
                            if current_user.role == 'artist'
                            # Delete all music belonging to the artist
                            music = Music.where(user_id: current_user.id)
                            music.destroy_all if music.any?
                        end
                  
                        # Delete the user account
                        unless current_user.destroy
                            raise ActiveRecord::Rollback, "Failed to delete user account"
                        end
                    end
                  
                    status 200
                        { message: 'User account deleted successfully' }
                  
                    rescue => e
                        error!({ error: e.message }, 422)
                    end
                end 

                desc 'update user details'
                params do
                    optional :name, type: String
                    optional :email, type: String
                    optional :profile_photo, type: String
                end

                put :update_user do
                    attrs = {}
                    attrs[:name] = params[:name] if params[:name]
                    attrs[:profile_photo] = params[:profile_photo] if params[:profile_photo]
                  
                    if params[:email]
                        existing_user = User.find_by(email: params[:email])
                        if existing_user && existing_user.id != current_user.id
                        error!({ error: 'Email already taken' }, 422)
                    end
                        attrs[:email] = params[:email]
                    end
                  
                    if current_user.update(attrs)
                        { message: 'User details updated successfully', user: current_user }
                    else
                        error!({ error: current_user.errors.full_messages }, 422)
                    end
                end 
            end
        end
    end
end